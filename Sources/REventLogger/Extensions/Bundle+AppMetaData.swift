import Foundation
import UIKit

@objc public protocol EventLoggerAppBundleable {
    var appId: String? { get }
    var appName: String? { get }
    var appVersion: String? { get }
}

extension Bundle: EventLoggerAppBundleable {
    private enum BundleKeys {
        static let bundleId = "CFBundleIdentifier"
        static let shortVersion = "CFBundleShortVersionString"
        static let appName = "CFBundleDisplayName"
    }

    public var appId: String? {
        object(forInfoDictionaryKey: BundleKeys.bundleId) as? String
    }

    public var appName: String? {
        object(forInfoDictionaryKey: BundleKeys.appName) as? String
    }

    public var appVersion: String? {
        object(forInfoDictionaryKey: BundleKeys.shortVersion) as? String
    }
}
