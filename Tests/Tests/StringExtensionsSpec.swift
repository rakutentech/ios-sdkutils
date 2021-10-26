import Foundation
import Quick
import Nimble
#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
#endif

class StringExtensionsSpec: QuickSpec {

    override func spec() {

        describe("StringExtensions") {

            describe("addEncodingForRFC3986UnreservedCharacters") {

                context("The string to encode is empty") {

                    it("should return empty string") {
                        let str = ""
                        expect(str.addEncodingForRFC3986UnreservedCharacters()).to(equal(""))
                    }
                }

                context("The string to encode is not empty") {

                    it("should return the same string when it does not contain RFC3986 reserved characters") {
                        let str = "sentence"
                        expect(str.addEncodingForRFC3986UnreservedCharacters()).to(equal("sentence"))
                    }

                    it("should return the encoded string when it contains RFC3986 reserved characters") {
                        let str = "sentence:#[]@!$&'()*+,;="
                        expect(str.addEncodingForRFC3986UnreservedCharacters()).to(equal("sentence%3A%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D"))
                    }
                }
            }

            describe("toBase64") {

                context("The string to encode is empty") {

                    it("should return empty string") {
                        let str = ""
                        expect(str.toBase64).to(equal(""))
                    }
                }

                context("The string to encode is not empty") {

                    it("should return Base64 encoded string") {
                        let str = "sentence"
                        expect(str.toBase64).to(equal("c2VudGVuY2U="))
                    }
                }
            }
        }
    }
}
