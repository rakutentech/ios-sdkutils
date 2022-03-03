import Foundation
import Quick
import Nimble
#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
@testable import RSDKUtilsNimble
#endif

final class NimbleExtensionsSpec: QuickSpec {

    override func spec() {
        describe("Expectation extensions") {

            context("toAfterTimeout()") {

                it("should finish after expected default timeout (1s)") {
                    let startTime = Date()
                    expect("test").toAfterTimeout(haveCount(4))
                    let secondsPaseed = Date().timeIntervalSince(startTime)
                    expect(secondsPaseed).to(beGreaterThan(0.8))
                    expect(secondsPaseed).to(beLessThan(1.2))
                }

                it("should finish after expected timeout") {
                    let startTime = Date()
                    expect("test").toAfterTimeout(equal("test"), timeout: 1.7)
                    let secondsPaseed = Date().timeIntervalSince(startTime)
                    expect(secondsPaseed).to(beGreaterThan(1.5))
                    expect(secondsPaseed).to(beLessThan(1.9))
                }

                it("should evaluate expectation only once") {
                    var evalCount = 0
                    let testClosure: () -> Int = {
                        evalCount += 1
                        return evalCount
                    }
                    expect(testClosure()).toAfterTimeout(equal(1))
                    expect(evalCount).to(equal(1))
                }
            }

            context("toAfterTimeoutNot()") {

                it("should finish after expected default timeout (1s)") {
                    let startTime = Date()
                    expect("test").toAfterTimeoutNot(haveCount(1))
                    let secondsPaseed = Date().timeIntervalSince(startTime)
                    expect(secondsPaseed).to(beGreaterThan(0.8))
                    expect(secondsPaseed).to(beLessThan(1.2))
                }

                it("should finish after expected timeout") {
                    let startTime = Date()
                    expect("test").toAfterTimeoutNot(beEmpty(), timeout: 1.7)
                    let secondsPaseed = Date().timeIntervalSince(startTime)
                    expect(secondsPaseed).to(beGreaterThan(1.5))
                    expect(secondsPaseed).to(beLessThan(1.9))
                }

                it("should evaluate expectation only once") {
                    var evalCount = 0
                    let testClosure: () -> Int = {
                        evalCount += 1
                        return evalCount
                    }
                    expect(testClosure()).toAfterTimeoutNot(beGreaterThan(1))
                    expect(evalCount).to(equal(1))
                }
            }
        }

        describe("global extension methods") {

            context("elementsEqualOrderAgnostic()") {

                it("should succeed if elements are in the same order") {
                    expect([1, 2, 3]).to(elementsEqualOrderAgnostic([1, 2, 3]))
                }

                it("should succeed if elements are not in the same order") {
                    expect([1, 2, 3]).to(elementsEqualOrderAgnostic([1, 3, 1]))
                }

                it("should succeed for empty collections") {
                    expect([String]()).to(elementsEqualOrderAgnostic([String]()))
                }

                it("should not succeed if elements number does not match") {
                    expect([1, 2, 3]).toNot(elementsEqualOrderAgnostic([1, 2]))
                    expect([1, 2, 3]).toNot(elementsEqualOrderAgnostic([1, 2, 3, 4]))
                    expect([1, 2, 3]).toNot(elementsEqualOrderAgnostic([]))
                }
            }
        }
    }
}
