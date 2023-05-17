import Foundation
import Quick
import Nimble
import XCTest
#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
@testable import RSDKUtilsTestHelpers
#endif

final class XCTestExtensionsSpec: QuickSpec {

    override func spec() {
        describe("XCTest extensions") {

            context("eventually(after:this:shouldEqual)") {

                it("should succeed without adding any delay if values were equal from the beginning") {
                    let startTime = Date()
                    self.eventually(this: { "test" }, shouldEqual: { "test" })

                    let secondsPassed = Date().timeIntervalSince(startTime)
                    expect(secondsPassed.rounded()).to(beLessThanOrEqualTo(0.1))
                }

                it("should succeed if values become equal") {
                    var value: String?
                    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                        value = "test"
                    }
                    self.eventually(this: { value }, shouldEqual: { "test" })
                }

                it("should evaluate (poll) expectation multiple times") {
                    var evalCount = 0
                    let testClosure: () -> Int? = {
                        evalCount += 1
                        return min(evalCount, 3) // I put a limit so the final XCTAssertEqual does not increment the value any further
                    }
                    self.eventually(this: testClosure, shouldEqual: { 3 })
                }
            }
        }
    }
}
