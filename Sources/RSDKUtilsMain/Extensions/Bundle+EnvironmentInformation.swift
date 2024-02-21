import Foundation
#if os(iOS)
import UIKit
#endif
#if os(watchOS)
import WatchKit
#endif

@objc public protocol BundleProtocol {
    var valueNotFound: String { get }
    func value(for key: String) -> String?
    func deviceModel() -> String
    func osVersion() -> String
    func sdkVersion() -> String
    func devicePlatform() -> String
    func deviceBrand() -> String
}

extension Bundle: BundleProtocol {
    public var valueNotFound: String {
        ""
    }

    public func osVersion() -> String {
        #if os(watchOS)
        WKInterfaceDevice.current().systemVersion
        #elseif os(iOS)
        UIDevice.current.systemVersion
        #elseif os(macOS)
        Host.current().name ?? ""
        #else
        ""
        #endif
    }

    // swiftlint:disable cyclomatic_complexity
    public func deviceModel() -> String {
        #if targetEnvironment(simulator)
            let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
            return identifier
        #else
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            switch identifier {
            case "iPhone6,1":   return "iPhone 5s"
            case "iPhone6,2":   return "iPhone 5s"
            case "iPhone7,2":   return "iPhone 6"
            case "iPhone7,1":   return "iPhone 6 Plus"
            case "iPhone8,1":   return "iPhone 6s"
            case "iPhone8,2":   return "iPhone 6s Plus"
            case "iPhone8,4":   return "iPhone SE"
            case "iPhone9,1":   return "iPhone 7"
            case "iPhone9,3":   return "iPhone 7"
            case "iPhone9,2":   return "iPhone 7 Plus"
            case "iPhone9,4":   return "iPhone 7 Plus"
            case "iPhone10,1":  return "iPhone 8"
            case "iPhone10,4":  return "iPhone 8"
            case "iPhone10,2":  return "iPhone 8 Plus"
            case "iPhone10,5":  return "iPhone 8 Plus"
            case "iPhone10,3":  return "iPhone X"
            case "iPhone10,6":  return "iPhone X"
            case "iPhone11,2":  return "iPhone XS"
            case "iPhone11,4":  return "iPhone XS Max"
            case "iPhone11,6":  return "iPhone XS Max"
            case "iPhone11,8":  return "iPhone XR"
            case "iPhone12,1":  return "iPhone 11"
            case "iPhone12,3":  return "iPhone 11 Pro"
            case "iPhone12,5":  return "iPhone 11 Pro Max"
            case "iPhone12,8":  return "iPhone SE (2nd generation)"
            case "iPhone13,1":  return "iPhone 12 mini"
            case "iPhone13,2":  return "iPhone 12"
            case "iPhone13,3":  return "iPhone 12 Pro"
            case "iPhone13,4":  return "iPhone 12 Pro Max"
            case "iPhone14,4":  return "iPhone 13 mini"
            case "iPhone14,5":  return "iPhone 13"
            case "iPhone14,2":  return "iPhone 13 Pro"
            case "iPhone14,3":  return "iPhone 13 Pro Max"
            case "iPhone14,1":  return "iPhone 13 Pro"
            case "iPhone14,6":  return "iPhone SE 3rd Gen"
            case "iPhone14,7":  return "iPhone 14"
            case "iPhone14,8":  return "iPhone 14 Plus"
            case "iPhone15,1":  return "iPhone 14 Mini"
            case "iPhone15,2":  return "iPhone 14 Pro"
            case "iPhone15,3":  return "iPhone 14 Pro Max"
            case "iPhone15,4":  return "iPhone 15"
            case "iPhone15,5":  return "iPhone 15 Plus"
            case "iPhone16,1":  return "iPhone 15 Pro"
            default:            return identifier
            }
        #endif
    }
    // swiftlint:enable cyclomatic_complexity

    public func sdkVersion() -> String {
        self.value(for: "CFBundleShortVersionString") ?? valueNotFound
    }

    public func value(for key: String) -> String? {
        self.object(forInfoDictionaryKey: key) as? String
    }

    public func devicePlatform() -> String {
        #if os(watchOS)
        WKInterfaceDevice.current().systemName
        #elseif os(iOS)
        UIDevice.current.systemName
        #else
        ""
        #endif
    }

    public func deviceBrand() -> String {
        #if os(watchOS)
        WKInterfaceDevice.current().model
        #elseif os(iOS)
        UIDevice.current.model
        #else
        ""
        #endif
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
