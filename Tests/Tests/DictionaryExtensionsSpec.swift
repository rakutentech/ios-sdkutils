import Foundation
import Quick
import Nimble
#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
#endif

class DictionaryExtensionsSpec: QuickSpec {

    override func spec() {

        describe("DictionaryExtensions") {

            describe("+=") {

                context("leftDictionary is empty") {
                    var leftDictionary: [String: String] = [:]

                    afterEach {
                        leftDictionary = [:]
                    }

                    context("rightDictionary is not empty") {
                        let rightDictionary: [String: String] = ["key1": "value1", "key2": "value2"]

                        it("should add rightDictionary entries to leftDictionary") {
                            leftDictionary += rightDictionary
                            expect(leftDictionary["key1"]).to(equal("value1"))
                            expect(leftDictionary["key2"]).to(equal("value2"))
                        }
                    }

                    context("rightDictionary is empty") {
                        let rightDictionary: [String: String] = [:]

                        it("should add nothing when there are no entries") {
                            leftDictionary += rightDictionary
                            expect(leftDictionary.isEmpty).to(beTrue())
                        }
                    }
                }

                context("leftDictionary is not empty") {
                    var leftDictionary: [String: String] = ["key3": "value3", "key4": "value4"]

                    afterEach {
                        leftDictionary = ["key3": "value3", "key4": "value4"]
                    }

                    context("rightDictionary is not empty") {
                        let rightDictionary: [String: String] = ["key1": "value1", "key2": "value2"]

                        it("should add rightDictionary entries to leftDictionary") {
                            leftDictionary += rightDictionary
                            expect(leftDictionary["key1"]).to(equal("value1"))
                            expect(leftDictionary["key2"]).to(equal("value2"))
                            expect(leftDictionary["key3"]).to(equal("value3"))
                            expect(leftDictionary["key4"]).to(equal("value4"))
                        }
                    }

                    context("rightDictionary is empty") {
                        let rightDictionary: [String: String] = [:]

                        it("should add nothing when there are no entries") {
                            leftDictionary += rightDictionary
                            expect(leftDictionary["key3"]).to(equal("value3"))
                            expect(leftDictionary["key4"]).to(equal("value4"))
                        }
                    }
                }
            }
        }
    }
}
