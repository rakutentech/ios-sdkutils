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
       return bundle.value(for: BundleKeys.bundleDisplayName) ?? bundle.value(for: BundleKeys.displayName) ?? bundle.valueNotFound
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

    var isAppExtension: Bool {
        bundle.bundleURL.pathExtension == "appex"
    }

    private func getRMCSDKsVersion() -> [String: String]? {
        guard let path = Bundle.rmcBundle?.path(forResource: BundleKeys.rmcVersionsInfoList, ofType: "plist") else {
            return nil
        }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            let versions = try decoder.decode(RMCSDKVersions.self, from: data)

            let stringDictionary: [String: String] = [
                "rmcSdkVersion": versions.rmcSdkVersion,
                "rmcInAppMessagingSdkVersion": versions.rmcInAppMessagingSdkVersion,
                "rmcAppblocksSdkVersion": versions.rmcAppblocksSdkVersion,
                "rmcPushSdkVersion": versions.rmcPushSdkVersion
            ]
            return stringDictionary
        } catch {
            Logger.debug("❌ Error decoding RmcInfo.plist: \(error)")
            return nil
        }
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
