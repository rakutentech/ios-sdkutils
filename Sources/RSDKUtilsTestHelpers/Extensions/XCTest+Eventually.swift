import Foundation
import XCTest

public extension XCTestCase {

    private static let eventuallyDispatchQueue = DispatchQueue(label: "XCTestHelper.eventually")

    func eventually<T: Equatable>(after time: TimeInterval = 5,
                                  this value: @escaping () -> T?,
                                  shouldEqual otherValue: @escaping () -> T) {

        let expectation = self.expectation(description: "eventually \(String(describing: value())) should equal \(String(describing: otherValue()))")

        let timer = Timer.scheduledTimer(withTimeInterval: 0.5,
                             repeats: true) { (timer) in
            XCTestCase.eventuallyDispatchQueue.async {
                if value() == otherValue() {
                    expectation.fulfill()
                    timer.invalidate()
                }
            }
        }
        timer.fire()

        wait(for: [expectation], timeout: time)
        timer.invalidate()
        XCTAssertEqual(value(), otherValue())
    }
}
