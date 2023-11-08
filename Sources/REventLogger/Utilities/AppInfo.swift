import Foundation

struct BundleInfo {
    static var appBundle: EventLoggerAppBundleable = Bundle.main

    static var appId: String? {
        appBundle.appId
    }

    static var appName: String? {
        appBundle.appName
    }

    static var appVersion: String? {
        appBundle.appVersion
    }
}
