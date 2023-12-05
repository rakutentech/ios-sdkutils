import Foundation
import UIKit
import Quick
import Nimble

@testable import REventLogger

class EnvironmentSpec: QuickSpec {
    override func spec() {
        describe("Environment") {
            let mockBundle = MockBundle()
            let mockDevice = MockDevice()
            let environment = Environment(bundle: mockBundle, device: mockDevice)
            context("when bundle has valid key-values") {
                it("has the expected appId") {
                    mockBundle.infoDictionaryMock["CFBundleIdentifier"] = "com.rakutentech"
                    expect(environment.appId).to(equal("com.rakutentech"))
                }

                it("has the expected appName") {
                    mockBundle.infoDictionaryMock["CFBundleDisplayName"] = "REventLogger"
                    expect(environment.appName).to(equal("REventLogger"))
                }

                it("has the expected appVersion") {
                    mockBundle.infoDictionaryMock["CFBundleShortVersionString"] = "1.2.3"
                    expect(environment.appVersion).to(equal("1.2.3"))
                }
            }

            context("when bundle has missing key-values") {
                it("has the expected appId") {
                    mockBundle.infoDictionaryMock.removeValue(forKey: "CFBundleIdentifier")
                    expect(environment.appId).to(equal(""))
                }

                it("has the expected appName") {
                    mockBundle.infoDictionaryMock.removeValue(forKey: "CFBundleDisplayName")
                    expect(environment.appName).to(equal(""))
                }

                it("has the expected appVersion") {
                    mockBundle.infoDictionaryMock.removeValue(forKey: "CFBundleShortVersionString")
                    expect(environment.appVersion).to(equal(""))
                }
            }

            context("when device has valid info") {
                it("has the expected devicePlatform") {
                    expect(environment.devicePlatform).to(equal("ios"))
                }

                it("has the expected deviceOsVersion") {
                    expect(environment.deviceOsVersion).to(equal("1.2.3"))
                }

                it("has the expected deviceBrand") {
                    expect(environment.deviceBrand).to(equal("apple"))
                }

                it("has the expected deviceModel") {
                    expect(environment.deviceModel).to(equal("arm64"))
                }

                it("has the expected deviceName") {
                    expect(environment.deviceName).to(equal("arm64"))
                }
            }
        }
    }
}

final class MockBundle: Bundle {
    var infoDictionaryMock = [String: Any]()

    override var infoDictionary: [String: Any]? {
        infoDictionaryMock
    }

    init() {
        // super.init(path:) creates a new instance only if `path` is not bound to any existing Bundle instance
        let path = Bundle.allBundles.first { $0.bundlePath.hasSuffix(".xctest") }?.bundleURL.deletingLastPathComponent().relativePath
        super.init(path: path!)!
        infoDictionaryMock.removeAll()
    }
}

final class MockDevice: UIDevice {
    override var systemName: String {
        "ios"
    }

    override var systemVersion: String {
        "1.2.3"
    }

    override var model: String {
        "apple"
    }
}
