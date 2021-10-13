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
        }
    }
}
