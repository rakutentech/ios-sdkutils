import Foundation

protocol Bundleable {
    var appId: String? { get }
    var appName: String? { get }
    var appVersion: String? { get }
}

extension Bundle: Bundleable {
    private enum BundleKeys {
        static let bundleId = "CFBundleIdentifier"
        static let shortVersion = "CFBundleShortVersionString"
        static let appName = "CFBundleDisplayName"
    }

    var appId: String? {
        object(forInfoDictionaryKey: BundleKeys.bundleId) as? String
    }

    var appName: String? {
        object(forInfoDictionaryKey: BundleKeys.appName) as? String
    }

    var appVersion: String? {
        object(forInfoDictionaryKey: BundleKeys.shortVersion) as? String
    }
}
