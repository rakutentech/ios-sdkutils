import Foundation
import UIKit

@objc public protocol BundleProtocol {
    var valueNotFound: String { get }
    func value(for key: String) -> String?
    func deviceModel() -> String
    func osVersion() -> String
    func sdkVersion() -> String
}

extension Bundle: BundleProtocol {
    public var valueNotFound: String {
        return ""
    }

    public func osVersion() -> String {
        return UIDevice.current.systemVersion
    }

    public func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        return String(bytes: Data(bytes: &systemInfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }

    public func sdkVersion() -> String {
        return Bundle(for: EnvironmentInformation.self).value(for: "CFBundleShortVersionString") ?? valueNotFound
    }

    public func value(for key: String) -> String? {
        return self.object(forInfoDictionaryKey: key) as? String
    }
}

public extension Bundle {

    static func sdkBundle(name: String) -> Bundle? {
        let defaultBundle = self.init(identifier: "org.cocoapods.\(name)") ?? .bundle(bundleIdSubstring: name)
        assert(defaultBundle != nil, "\(name) SDK is not integrated properly - framework bundle not found")
        return defaultBundle
    }

    static func bundle(bundleIdSubstring: String) -> Bundle? {
        return (allBundles + allFrameworks).first(where: { $0.bundleIdentifier?.contains(bundleIdSubstring) == true })
    }
}
