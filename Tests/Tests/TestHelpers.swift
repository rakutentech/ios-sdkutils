@testable import RSDKUtils

class BundleMock: BundleProtocol {
    var mockRASAppId: String?
    var mockBundleId: String?
    var mockBundleVersion: String?
    var mockDeviceModel: String?
    var mockOsVersion: String?
    var mockNotFound: String?

    func value(for key: String) -> String? {
        switch key {
        case "CFBundleIdentifier":
            return mockBundleId
        case "CFBundleShortVersionString":
            return mockBundleVersion
        case "RASApplicationIdentifier":
            return mockRASAppId
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
}
