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

                it("should succeed immediately if values were equal from the beginning") {
                    let startTime = Date()
                    self.eventually(this: { "test" }, shouldEqual: { "test" })

                    let secondsPaseed = Date().timeIntervalSince(startTime)
                    expect(secondsPaseed).to(beLessThan(0.2))
                }

                it("should succeed if values become equal") {
                    var value: String?
                    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                        value = "test"
                    }
                    self.eventually(this: { value }, shouldEqual: { "test" })
                }

                it("should fail after expected timeout if values did not become equal") {
                    let startTime = Date()
                    XCTExpectFailure()
                    self.eventually(after: 2, this: { "test" }, shouldEqual: { "test2" })

                    let secondsPaseed = Date().timeIntervalSince(startTime)
                    expect(secondsPaseed).to(beGreaterThan(1.8))
                    expect(secondsPaseed).to(beLessThan(2.2))
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
