import Foundation
import UIKit
import Quick
import Nimble
#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
@testable import REventLogger
#endif

final class REventLoggerEnvironmentSpec: QuickSpec {
    override func spec() {
        describe("REventLoggerEnvironment") {
            let mockBundle = BundleMock()
            let environment = REventLoggerEnvironment(bundle: mockBundle)

            context("when bundle has valid info") {
                it("has the expected appId") {
                    mockBundle.mockBundleId = "com.rakutentech"
                    expect(environment.appId).to(equal("com.rakutentech"))
                }

                it("has the expected appName") {
                    mockBundle.mockAppName = "REventLogger"
                    expect(environment.appName).to(equal("REventLogger"))
                }

                it("has the expected appVersion") {
                    mockBundle.mockBundleVersion = "1.2.3"
                    expect(environment.appVersion).to(equal("1.2.3"))
                }

                it("has the expected devicePlatform") {
                    mockBundle.mockDevicePlatform = "ios"
                    expect(environment.devicePlatform).to(equal("ios"))
                }

                it("has the expected deviceOsVersion") {
                    mockBundle.mockOsVersion = "1.2.3"
                    expect(environment.deviceOsVersion).to(equal("1.2.3"))
                }

                it("has the expected deviceBrand") {
                    mockBundle.mockDeviceBrand = "iPhone"
                    expect(environment.deviceBrand).to(equal("iPhone"))
                }

                it("has the expected deviceModel") {
                    mockBundle.mockDeviceModel = "arm64"
                    expect(environment.deviceModel).to(equal("arm64"))
                }

                it("has the expected deviceName") {
                    mockBundle.mockDeviceModel = "arm64"
                    expect(environment.deviceName).to(equal("arm64"))
                }
            }

            context("when bundle has missing info") {
                it("should not contain the expected appId") {
                    mockBundle.mockBundleId = nil
                    expect(environment.appId).to(equal(""))
                }

                it("should not contain the expected appName") {
                    mockBundle.mockAppName = nil
                    expect(environment.appName).to(equal(""))
                }

                it("should not contain the expected appVersion") {
                    mockBundle.mockBundleVersion = nil
                    expect(environment.appVersion).to(equal(""))
                }

                it("should not contain the expected appVersion") {
                    mockBundle.mockBundleVersion = nil
                    expect(environment.appVersion).to(equal(""))
                }

                it("should not contain the expected devicePlatform") {
                    mockBundle.mockDevicePlatform = nil
                    expect(environment.devicePlatform).to(equal(""))
                }

                it("should not contain the expected deviceOsVersion") {
                    mockBundle.mockOsVersion = nil
                    expect(environment.deviceOsVersion).to(equal(""))
                }

                it("should not contain the expected deviceBrand") {
                    mockBundle.mockDeviceBrand = nil
                    expect(environment.deviceBrand).to(equal(""))
                }

                it("should not contain the expected deviceModel") {
                    mockBundle.mockDeviceModel = nil
                    expect(environment.deviceModel).to(equal(""))
                }

                it("has the expected deviceName") {
                    mockBundle.mockDeviceModel = nil
                    expect(environment.deviceName).to(equal(""))
                }
            }
        }
    }
}
