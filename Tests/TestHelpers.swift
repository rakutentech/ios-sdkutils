@testable import RSDKUtils

class BundleMock: BundleProtocol {
    var mockAppId: String?
    var mockAppName: String?
    var mockAppVersion: String?
    var mockDeviceModel: String?
    var mockOsVersion: String?
    var mockSdkVersion: String?
    var mockNotFound: String?

    func value(for key: String) -> String? {
        switch key {
        case "CFBundleIdentifier":
            return mockAppName
        case "CFBundleDisplayName":
            return mockAppName
        case "CFBundleShortVersionString":
            return mockAppVersion
        case "RASApplicationIdentifier":
            return mockAppId
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
        return mockSdkVersion ?? valueNotFound
    }
}
