import Foundation
import UIKit

private enum BundleKeys {
    static let bundleIdentifier = "CFBundleIdentifier"
    static let shortVersion = "CFBundleShortVersionString"
    static let displayName = "CFBundleDisplayName"
}

final class Environment {
    private let bundle: BundleInfoProtocol
    private let device: DeviceSupportProtocol

    init(bundle: BundleInfoProtocol = Bundle.main,
         device: DeviceSupportProtocol = UIDevice.current) {
        self.bundle = bundle
        self.device = device
    }

    var appId: String {
        bundle.value(for: BundleKeys.bundleIdentifier) ?? bundle.valueNotFound
    }

    var appName: String {
        bundle.value(for: BundleKeys.displayName) ?? bundle.valueNotFound
    }

    var appVersion: String {
        bundle.value(for: BundleKeys.shortVersion) ?? bundle.valueNotFound
    }

    var devicePlatform: String {
        device.systemName
    }

    var deviceOsVersion: String {
        device.systemVersion
    }

    var deviceBrand: String {
        device.model
    }

    var deviceName: String {
        device.deviceModelName
    }

    var deviceModel: String {
        device.deviceModelName
    }
}

private extension DeviceSupportProtocol {
    var deviceModelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        return String(bytes: Data(bytes: &systemInfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
}
