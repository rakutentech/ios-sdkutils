import Foundation
import UIKit
#if canImport(RSDKUtilsMain)
import RSDKUtilsMain
#endif

private enum BundleKeys {
    static let bundleIdentifier = "CFBundleIdentifier"
    static let shortVersion = "CFBundleShortVersionString"
    static let displayName = "CFBundleName"
    static let bundleDisplayName = "CFBundleDisplayName"
    static let rmcBundleName = "RMC_RMC.bundle"
    static let rmcVersionsInfoList = "RmcInfo"
}

final class REventLoggerEnvironment {
    private let bundle: BundleProtocol
    private var rmcSDKsVersion: [String: String]?

    init(bundle: BundleProtocol = Bundle.main) {
        self.bundle = bundle
    }

    var appId: String {
        bundle.value(for: BundleKeys.bundleIdentifier) ?? bundle.valueNotFound
    }

    var appName: String {
        if let bundleDisplayName = bundle.value(for: BundleKeys.bundleDisplayName) {
            return bundleDisplayName
        } else if let bundleName = bundle.value(for: BundleKeys.displayName) {
            return bundleName
        }
        else { return bundle.valueNotFound }
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

    var rmcSDKs: [String: String]? {
        if rmcSDKsVersion == nil {
            rmcSDKsVersion = getRMCSDKsVersion()
        }
        return rmcSDKsVersion
    }

    private func getRMCSDKsVersion() -> [String: String]? {
        guard let path = Bundle.rmcBundle?.path(forResource: BundleKeys.rmcVersionsInfoList, ofType: "plist") else { return nil }
        return NSDictionary(contentsOfFile: path) as? [String: String]
    }
}

extension Bundle {
    static var rmcBundle: Bundle? {
        guard let rmcBundleUrl = main.resourceURL?.appendingPathComponent(BundleKeys.rmcBundleName),
              let bundle = Bundle(url: rmcBundleUrl) else {
            return nil
        }
        return bundle
    }
}
