import Foundation
import Quick
import Nimble
#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
#endif

class DataExtensionsSpec: QuickSpec {

    override func spec() {

        describe("DataExtensions") {

            context("hexString") {

                it("will return empty string for empty data") {
                    let data = Data()
                    expect(data.hexString).to(beEmpty())
                }

                it("will return expected hex string from data") {
                    let data = Data(base64Encoded: "EjRWeJCrze8=")!
                    expect(data.hexString).to(equal("1234567890abcdef"))
                }
            }

            context("sha256Hex") {
                it("will return empty string for empty data") {
                    let data = Data()
                    expect(data.sha256Hex).to(beNil())
                }

                it("will return expected SHA256 hash from 'hello world'") {
                    let data = Data("hello world".utf8)
                    expect(data.sha256Hex).to(equal("b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9"))
                }
            }
        }
    }
}
