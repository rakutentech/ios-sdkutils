import Foundation
import UIKit

public protocol BundleProtocol {
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
