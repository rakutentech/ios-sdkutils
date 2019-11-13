import Foundation
import UIKit

internal protocol BundleProtocol {
    var valueNotFound: String { get }
    func value(for key: String) -> String?
    func deviceModel() -> String
    func osVersion() -> String
    func sdkVersion() -> String
}

extension Bundle: BundleProtocol {
    var valueNotFound: String {
        return ""
    }

    func osVersion() -> String {
        return UIDevice.current.systemVersion
    }

    func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        return String(bytes: Data(bytes: &systemInfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }

    func sdkVersion() -> String {
        return Bundle(for: EnvironmentInformation.self).value(for: "CFBundleShortVersionString") ?? valueNotFound
    }

    func value(for key: String) -> String? {
        return self.object(forInfoDictionaryKey: key) as? String
    }
}

internal class EnvironmentInformation: NSObject {
    let bundle: BundleProtocol

    var appId: String {
        return bundle.value(for: "RASApplicationIdentifier" as String) ?? bundle.valueNotFound
    }
    var appName: String {
        return bundle.value(for: "CFBundleIdentifier" as String) ?? bundle.valueNotFound
    }
    var appVersion: String {
        return bundle.value(for: "CFBundleShortVersionString" as String) ?? bundle.valueNotFound
    }
    var deviceModel: String {
        return bundle.deviceModel()
    }
    var osVersion: String {
        return bundle.osVersion()
    }
    var sdkVersion: String {
        return bundle.sdkVersion()
    }

    init(bundle: BundleProtocol = Bundle.main) {
        self.bundle = bundle
    }
}

public extension URLRequest {
    mutating func setRASHeaders(for sdk: String) {
        let env = EnvironmentInformation()
        setHeader("ras-app-id", env.appId)
        setHeader("ras-device-model", env.deviceModel)
        setHeader("ras-os-version", env.osVersion)
        setHeader("ras-sdk-name", sdk)
        setHeader("ras-sdk-version", env.sdkVersion)
        setHeader("ras-app-name", env.appName)
        setHeader("ras-app-version", env.appVersion)
    }

    fileprivate mutating func setHeader(_ name: String, _ value: String) {
        if value.count > 0 {
            setValue(value, forHTTPHeaderField: name)
        }
    }
}

@objc public extension NSMutableURLRequest {
    func setRASHeaders(for sdk: String) {
        let env = EnvironmentInformation()
        setHeader("ras-app-id", env.appId)
        setHeader("ras-device-model", env.deviceModel)
        setHeader("ras-os-version", env.osVersion)
        setHeader("ras-sdk-name", sdk)
        setHeader("ras-sdk-version", env.sdkVersion)
        setHeader("ras-app-name", env.appName)
        setHeader("ras-app-version", env.appVersion)
    }

    fileprivate func setHeader(_ name: String, _ value: String) {
        if value.count > 0 {
            setValue(value, forHTTPHeaderField: name)
        }
    }
}
