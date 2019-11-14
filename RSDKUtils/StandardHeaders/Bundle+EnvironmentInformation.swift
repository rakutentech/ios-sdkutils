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
