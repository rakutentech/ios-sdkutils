import SystemConfiguration
import Foundation
#if canImport(Logger)
import Logger
#endif

public protocol ReachabilityType {
    var connection: Reachability.Connection { get }

    func addObserver(_ observer: ReachabilityObserver)
    func removeObserver(_ observer: ReachabilityObserver)
}

public protocol ReachabilityObserver: AnyObject {
    func reachabilityChanged(_ reachability: ReachabilityType)
}

/// Class that wraps `SCNetworkReachability` and provides
/// information on network connectivity state
public class Reachability: ReachabilityType {

    private typealias UnmanagedWeakSelf = Unmanaged<WeakWrapper<Reachability>>

    public enum Connection {
        case unavailable
        case wifi
        case cellular

        var isAvailable: Bool {
            return [.wifi, .cellular].contains(self)
        }
    }

    private var observers = [WeakWrapper<ReachabilityObserver>]()
    private(set) var notifierRunning = false
    private let reachabilityRef: SCNetworkReachability
    private let reachabilitySerialQueue = DispatchQueue(label: "RSDKUtils.Reachability", qos: .default)
    private let notificationQueue = DispatchQueue.main
    private(set) var flags: SCNetworkReachabilityFlags? {
        didSet {
            guard flags != oldValue else { return }
            notifyReachabilityChanged()
        }
    }

    /// Set to `false` to force Reachability.connection to `.unavailable` when on cellular connection (default value `true`)
    public var allowsCellularConnection = true
    public var connection: Connection {
        if flags == nil {
            updateReachabilityFlags()
        }

        switch flags?.connection {
        case .unavailable?, nil:
            return .unavailable
        case .cellular?:
            return allowsCellularConnection ? .cellular : .unavailable
        case .wifi?:
            return .wifi
        }
    }
    public var description: String {
        return flags?.description ?? "unavailable flags"
    }

    /// Creates new Reachability and starts notifying
    /// - Parameter hostname: name of the host to check connectivity against
    /// - Returns: new Reachability instance or `nil` if hostname is invalid
    public init?(hostname: String) {
        guard let ref = SCNetworkReachabilityCreateWithName(nil, hostname) else {
            Reachability.logDebug("Reachability couldn't be set up with host:\(hostname)")
            return nil
        }
        self.reachabilityRef = ref

        startNotifier()
    }

    /// Convenience method to create new Reachability with URL
    /// A hostname will be extracted from url and used to create an instance
    /// (ex. 'https://google.com/maps') It will be turned into 'google.com'
    /// - Parameter url: url containing hostname
    /// - Returns: new Reachability instance or `nil` if hostname couldn't be extracted
    public convenience init?(url: URL) {
        guard let hostname = url.host else {
            Reachability.logDebug("Reachability couldn't be set up with url:\(url)")
            return nil
        }
        self.init(hostname: hostname)
    }

    deinit {
        stopNotifier()
        // reachabilityRef is released automatically
    }

    public func addObserver(_ observer: ReachabilityObserver) {
        observers.append(WeakWrapper(value: observer))
    }

    public func removeObserver(_ observer: ReachabilityObserver) {
        observers.removeAll { $0.value === observer }
    }

    private func startNotifier() {
        guard !notifierRunning else { return }

        let callback: SCNetworkReachabilityCallBack = { (_, flags, info) in
            guard let info = info else { return }

            let weakSelf = UnmanagedWeakSelf.fromOpaque(info).takeUnretainedValue()
            weakSelf.value?.flags = flags
        }

        let weakSelf = WeakWrapper<Reachability>(value: self)
        let opaqueWeakSelf = UnmanagedWeakSelf.passUnretained(weakSelf).toOpaque()

        var context = SCNetworkReachabilityContext(
            version: 0,
            info: UnsafeMutableRawPointer(opaqueWeakSelf),
            retain: { (info: UnsafeRawPointer) -> UnsafeRawPointer in
                let unmanagedWeakSelf = UnmanagedWeakSelf.fromOpaque(info)
                _ = unmanagedWeakSelf.retain()
                return UnsafeRawPointer(unmanagedWeakSelf.toOpaque())
            },
            release: { (info: UnsafeRawPointer) -> Void in
                let unmanagedWeakSelf = UnmanagedWeakSelf.fromOpaque(info)
                unmanagedWeakSelf.release()
            },
            copyDescription: { (info: UnsafeRawPointer) -> Unmanaged<CFString> in
                let unmanagedWeakSelf = UnmanagedWeakSelf.fromOpaque(info)
                let weakSelf = unmanagedWeakSelf.takeUnretainedValue()
                let description = weakSelf.value?.description ?? "nil"
                return Unmanaged.passRetained(description as CFString)
            }
        )

        guard SCNetworkReachabilitySetCallback(reachabilityRef, callback, &context) else {
            Reachability.logDebug("Reachability was unable to set callback. Stopping notifier...")
            stopNotifier()
            return
        }

        guard SCNetworkReachabilitySetDispatchQueue(reachabilityRef, reachabilitySerialQueue) else {
            Reachability.logDebug("Reachability was unable to set dispatch queue. Stopping notifier...")
            stopNotifier()
            return
        }

        guard updateReachabilityFlags() else {
            Reachability.logDebug("Reachability was unable set flags. Stopping notifier...")
            stopNotifier()
            return
        }

        notifierRunning = true
    }

    private func stopNotifier() {
        SCNetworkReachabilitySetCallback(reachabilityRef, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachabilityRef, nil)
        notifierRunning = false
    }

    @discardableResult
    private func updateReachabilityFlags() -> Bool {
        return reachabilitySerialQueue.sync { [unowned self] in
            var flags = SCNetworkReachabilityFlags()
            guard SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags) else {
                return false
            }

            self.flags = flags
            return true
        }
    }

    private func notifyReachabilityChanged() {
        Reachability.logDebug("Reachability: \(connection)")
        notificationQueue.async { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.observers.forEach { $0.value?.reachabilityChanged(weakSelf) }
        }
    }

    private static func logDebug(_ message: String) {
        #if canImport(Logger)
        Logger.debug(message)
        #endif
    }
}

extension SCNetworkReachabilityFlags {

    var connection: Reachability.Connection {
        guard isReachableFlagSet else { return .unavailable }

        // If we're reachable, but not on an iOS device (i.e. simulator), we must be on WiFi
        #if targetEnvironment(simulator)
        return .wifi
        #else
        var connection = Reachability.Connection.unavailable

        if !isConnectionRequiredFlagSet {
            connection = .wifi
        }

        if isConnectionOnTrafficOrDemandFlagSet {
            if !isInterventionRequiredFlagSet {
                connection = .wifi
            }
        }

        if isOnWWANFlagSet {
            connection = .cellular
        }

        return connection
        #endif
    }

    var isOnWWANFlagSet: Bool {
        #if os(iOS)
        return contains(.isWWAN)
        #else
        return false
        #endif
    }
    var isReachableFlagSet: Bool {
        return contains(.reachable)
    }
    var isConnectionRequiredFlagSet: Bool {
        return contains(.connectionRequired)
    }
    var isInterventionRequiredFlagSet: Bool {
        return contains(.interventionRequired)
    }
    var isConnectionOnTrafficFlagSet: Bool {
        return contains(.connectionOnTraffic)
    }
    var isConnectionOnDemandFlagSet: Bool {
        return contains(.connectionOnDemand)
    }
    var isConnectionOnTrafficOrDemandFlagSet: Bool {
        return !intersection([.connectionOnTraffic, .connectionOnDemand]).isEmpty
    }
    var isTransientConnectionFlagSet: Bool {
        return contains(.transientConnection)
    }
    var isLocalAddressFlagSet: Bool {
        return contains(.isLocalAddress)
    }
    var isDirectFlagSet: Bool {
        return contains(.isDirect)
    }
    var isConnectionRequiredAndTransientFlagSet: Bool {
        return intersection([.connectionRequired, .transientConnection]) == [.connectionRequired, .transientConnection]
    }

    var description: String {
        let W = isOnWWANFlagSet ? "W" : "-"
        let R = isReachableFlagSet ? "R" : "-"
        let c = isConnectionRequiredFlagSet ? "c" : "-"
        let t = isTransientConnectionFlagSet ? "t" : "-"
        let i = isInterventionRequiredFlagSet ? "i" : "-"
        let C = isConnectionOnTrafficFlagSet ? "C" : "-"
        let D = isConnectionOnDemandFlagSet ? "D" : "-"
        let l = isLocalAddressFlagSet ? "l" : "-"
        let d = isDirectFlagSet ? "d" : "-"

        return "\(W)\(R) \(c)\(t)\(i)\(C)\(D)\(l)\(d)"
    }
}
