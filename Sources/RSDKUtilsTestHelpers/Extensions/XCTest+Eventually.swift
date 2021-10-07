import Foundation
import XCTest

public extension XCTestCase {

    func eventually<T: Equatable>(after time: TimeInterval = 5, this value: @escaping () -> T?, shouldEqual otherValue: @escaping () -> T) {

        let expectation = self.expectation(description: "eventually \(String(describing: value())) should equal \(String(describing: otherValue()))")

        Timer.scheduledTimer(withTimeInterval: 0.5,
                             repeats: true) { (timer) in
            DispatchQueue.main.async {
                if value() == otherValue() {
                    expectation.fulfill()
                    timer.invalidate()
                }
            }
        }.fire()

        wait(for: [expectation], timeout: time)
        XCTAssertEqual(value(), otherValue())
    }
}
