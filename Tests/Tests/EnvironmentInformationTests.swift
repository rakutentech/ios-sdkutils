import Quick
import Nimble
@testable import RSDKUtils

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
                mockBundle.mockRASAppId = "fooAppId"

                let environment = EnvironmentInformation(bundle: mockBundle)

                expect(environment.appId).to(equal("fooAppId"))
            }

            it("has the expected app name") {
                let mockBundle = BundleMock()
                mockBundle.mockBundleId = "fooAppName"

                let environment = EnvironmentInformation(bundle: mockBundle)

                expect(environment.bundleName).to(equal("fooAppName"))
            }

            it("has the expected version") {
                let mockBundle = BundleMock()
                mockBundle.mockBundleVersion = "fooVersion"

                let environment = EnvironmentInformation(bundle: mockBundle)

                expect(environment.version).to(equal("fooVersion"))
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
        }
        context("when bundle does not have valid key values") {
            let mockBundleInvalid = BundleMock()
            mockBundleInvalid.mockNotFound = "not-found"
            let environment = EnvironmentInformation(bundle: mockBundleInvalid)

            it("will return the 'not found' value when app id can't be read") {
                expect(environment.appId).to(equal(mockBundleInvalid.valueNotFound))
            }

            it("will return the 'not found' value when app name can't be read") {
                expect(environment.bundleName).to(equal(mockBundleInvalid.valueNotFound))
            }

            it("will return the 'not found' value when app version can't be read") {
                expect(environment.version).to(equal(mockBundleInvalid.valueNotFound))
            }

            it("will return the 'not found' value when device model can't be read") {
                expect(environment.deviceModel).to(equal(mockBundleInvalid.valueNotFound))
            }

            it("will return the 'not found' value when device os version can't be read") {
                expect(environment.osVersion).to(equal(mockBundleInvalid.valueNotFound))
            }
        }
    }
}
