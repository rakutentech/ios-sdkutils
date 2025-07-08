import Foundation
#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
#endif

class BundleMock: BundleProtocol {
    var bundleURL: URL = URL(string: "mock-bundle-url")!
    var mockRASAppId: String?
    var mockAppName: String?
    var mockBundleId: String?
    var mockBundleVersion: String?
    var mockDeviceModel: String?
    var mockOsVersion: String?
    var mockDevicePlatform: String?
    var mockDeviceBrand: String?
    var mockNotFound: String?

    func value(for key: String) -> String? {
        switch key {
        case "CFBundleIdentifier":
            return mockBundleId
        case "CFBundleShortVersionString":
            return mockBundleVersion
        case "RASApplicationIdentifier":
            return mockRASAppId
        case "CFBundleDisplayName":
            return mockAppName
        default:
            return nil
        }
    }

    var valueNotFound: String {
        return mockNotFound ?? ""
    }

    func deviceModel() -> String {
        return mockDeviceModel ?? valueNotFound
    }

    func osVersion() -> String {
        return mockOsVersion ?? valueNotFound
    }

    func sdkVersion() -> String {
        return mockBundleVersion ?? valueNotFound
    }

    func devicePlatform() -> String {
        return mockDevicePlatform ?? valueNotFound
    }

    func deviceBrand() -> String {
        return mockDeviceBrand ?? valueNotFound
    }
}
