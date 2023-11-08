import Foundation
import Quick
import Nimble

@testable import REventLogger

class AppBundleSpec: QuickSpec {

    override func spec() {
        describe("check bundle info") {
            let bundleInfoMock = BundleInfoMock()
            BundleInfo.appBundle = bundleInfoMock
            
            context("validate applicationId") {
                it("should return nil if CFBundleIdentifier is not set") {
                    bundleInfoMock.infoDictionaryMock.removeValue(forKey: "CFBundleIdentifier")
                    expect(BundleInfo.appId).to(beNil())
                }

                it("should return expected applicationId") {
                    bundleInfoMock.infoDictionaryMock["CFBundleIdentifier"] = "bundle.id"
                    expect(BundleInfo.appId).to(equal("bundle.id"))
                }
            }

            context("validate appVersion") {
                it("should return nil if CFBundleShortVersionString is not set") {
                    bundleInfoMock.infoDictionaryMock.removeValue(forKey: "CFBundleShortVersionString")
                    expect(BundleInfo.appVersion).to(beNil())
                }

                it("should return expected appVersion") {
                    bundleInfoMock.infoDictionaryMock["CFBundleShortVersionString"] = "1.2.3"
                    expect(BundleInfo.appVersion).to(equal("1.2.3"))
                }
            }
            
            context("validate appName") {
                it("should return nil if CFBundleDisplayName is not set") {
                    bundleInfoMock.infoDictionaryMock.removeValue(forKey: "CFBundleDisplayName")
                    expect(BundleInfo.appName).to(beNil())
                }

                it("should return expected appVersion") {
                    bundleInfoMock.infoDictionaryMock["CFBundleDisplayName"] = "MyRakuApp"
                    expect(BundleInfo.appName).to(equal("MyRakuApp"))
                }
            }
        }
    }
}

class BundleInfoMock: Bundle {
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
