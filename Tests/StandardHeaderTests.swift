import Quick
import Nimble
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

class EnvironmentInformationSpec: QuickSpec {
    override func spec() {
        it("uses the main bundle when no bundle parameter is supplied") {
            let environment = EnvironmentInformation()
            let bundle = environment.bundle as? Bundle ?? Bundle(for: EnvironmentInformationSpec.self)

            expect(bundle).to(equal(Bundle.main))
        }
        context("when bundle has valid key-values") {

            it("has the expected app id") {
                let mockBundle = BundleMock()
                mockBundle.mockAppId = "fooAppId"

                let environment = EnvironmentInformation(bundle: mockBundle)

                expect(environment.appId).to(equal("fooAppId"))
            }

            it("has the expected app name") {
                let mockBundle = BundleMock()
                mockBundle.mockAppName = "fooAppName"

                let environment = EnvironmentInformation(bundle: mockBundle)

                expect(environment.appName).to(equal("fooAppName"))
            }

            it("has the expected app version") {
                let mockBundle = BundleMock()
                mockBundle.mockAppVersion = "fooAppVersion"

                let environment = EnvironmentInformation(bundle: mockBundle)

                expect(environment.appVersion).to(equal("fooAppVersion"))
            }

            it("has the expected OS version") {
                let mockBundle = BundleMock()
                mockBundle.mockOsVersion = "fooOSVersion"

                let environment = EnvironmentInformation(bundle: mockBundle)

                expect(environment.osVersion).to(equal("fooOSVersion"))
            }

            it("has the expected device model") {
                let mockBundle = BundleMock()
                mockBundle.mockDeviceModel = "fooModel"

                let environment = EnvironmentInformation(bundle: mockBundle)

                expect(environment.deviceModel).to(equal("fooModel"))
            }

            it("has the expected sdk version") {
                let mockBundle = BundleMock()
                mockBundle.mockSdkVersion = "fooSDKVersion"

                let environment = EnvironmentInformation(bundle: mockBundle)

                expect(environment.sdkVersion).to(equal("fooSDKVersion"))
            }
        }
        context("when bundle does not have valid key values") {
            let mockBundleInvalid = BundleMock()
            mockBundleInvalid.mockNotFound = "not-found"
            let environment = EnvironmentInformation(bundle: mockBundleInvalid)

            it("will return the 'not found' value when app id can't be read") {
                expect(environment.appId).to(equal(mockBundleInvalid.valueNotFound))
            }

            it("will return the 'not found' value when app name can't be read") {
                expect(environment.appName).to(equal(mockBundleInvalid.valueNotFound))
            }

            it("will return the 'not found' value when app version can't be read") {
                expect(environment.appVersion).to(equal(mockBundleInvalid.valueNotFound))
            }

            it("will return the 'not found' value when device model can't be read") {
                expect(environment.deviceModel).to(equal(mockBundleInvalid.valueNotFound))
            }

            it("will return the 'not found' value when device os version can't be read") {
                expect(environment.osVersion).to(equal(mockBundleInvalid.valueNotFound))
            }

            it("will return the 'not found' value when sdk version can't be read") {
                expect(environment.sdkVersion).to(equal(mockBundleInvalid.valueNotFound))
            }
        }
    }
}
