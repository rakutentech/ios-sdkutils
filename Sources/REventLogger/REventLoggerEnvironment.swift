import Foundation
import UIKit
#if canImport(RSDKUtilsMain)
import RSDKUtilsMain
#endif

private enum BundleKeys {
    static let bundleIdentifier = "CFBundleIdentifier"
    static let shortVersion = "CFBundleShortVersionString"
    static let displayName = "CFBundleDisplayName"
}

final class REventLoggerEnvironment {
    private let bundle: BundleProtocol

    init(bundle: BundleProtocol = Bundle.main) {
        self.bundle = bundle
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

    var deviceName: String {
        bundle.deviceModel()
    }

    var deviceModel: String {
        bundle.deviceModel()
    }

    var devicePlatform: String {
        bundle.devicePlatform()
    }

    var deviceOsVersion: String {
        bundle.osVersion()
    }

    var deviceBrand: String {
        bundle.deviceBrand()
    }

    var rmcBundle: Bundle? {
        .rmcResources
    }

    var rmcSdks: [String: String]? {
        rmcBundle?.getRMCSdks()
    }
}

internal extension Bundle {
    static var rmcResources: Bundle? {
        guard let rmcBundleUrl = main.resourceURL?.appendingPathComponent("RMC_RMC.bundle"),
              let bundle = Bundle(url: rmcBundleUrl) else {
            return nil
        }
        return bundle
    }

    fileprivate func getRMCSdks() -> [String: String]? {
        guard let path = path(forResource: "RmcInfo", ofType: "plist") else { return nil }
        return NSDictionary(contentsOfFile: path) as? [String: String]
    }
}
