import Foundation
import UIKit
#if os(watchOS)
import WatchKit
#endif

@objc public protocol BundleProtocol {
    var valueNotFound: String { get }
    func value(for key: String) -> String?
    func deviceModel() -> String
    func osVersion() -> String
    func sdkVersion() -> String
}

extension Bundle: BundleProtocol {
    public var valueNotFound: String {
        ""
    }

    public func osVersion() -> String {
        #if os(watchOS)
        WKInterfaceDevice.current().systemVersion
        #else
        UIDevice.current.systemVersion
        #endif
    }

    public func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        return String(bytes: Data(bytes: &systemInfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }

    public func sdkVersion() -> String {
        Bundle(for: EnvironmentInformation.self).value(for: "CFBundleShortVersionString") ?? valueNotFound
    }

    public func value(for key: String) -> String? {
        self.object(forInfoDictionaryKey: key) as? String
    }
}

public extension Bundle {

    static func sdkBundle(name: String) -> Bundle? {
        let defaultBundle = self.init(identifier: "org.cocoapods.\(name)") ?? .frameworkBundle(bundleIdPhrase: name)
        assert(defaultBundle != nil, "\(name) SDK is not integrated properly - framework bundle not found")
        return defaultBundle
    }

    static func assetsBundle(bundleIdPhrase: String) -> Bundle? {
        allBundles.first(where: { $0.bundleIdentifier?.contains(bundleIdPhrase) == true })
    }

    static func frameworkBundle(bundleIdPhrase: String) -> Bundle? {
        allFrameworks.first(where: { $0.bundleIdentifier?.contains(bundleIdPhrase) == true })
    }

    var isAppExtension: Bool {
        bundleURL.pathExtension == "appex"
    }
}
