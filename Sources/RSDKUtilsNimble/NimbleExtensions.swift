import Foundation
import Nimble

public extension SyncExpectation {

    func toAfterTimeout(file: FileString = #file,
                        line: UInt = #line,
                        _ predicate: Nimble.Matcher<Value>,
                        timeout: TimeInterval = 1.0) {

        let timeForExecution: TimeInterval = 1.0
        let totalTimeoutMS = Int((timeout + timeForExecution) * TimeInterval(USEC_PER_SEC))
        waitUntil(timeout: .microseconds(totalTimeoutMS)) { done in
            DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
                expect(file: file, line: line, evaluateExpression).to(predicate)
                done()
            }
        }
    }

    func toAfterTimeoutNot(file: FileString = #file,
                           line: UInt = #line,
                           _ predicate: Nimble.Matcher<Value>,
                           timeout: TimeInterval = 1.0) {

        let timeForExecution: TimeInterval = 1.0
        let totalTimeoutMS = Int((timeout + timeForExecution) * TimeInterval(USEC_PER_SEC))
        waitUntil(timeout: .microseconds(totalTimeoutMS)) { done in
            DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
                expect(file: file, line: line, evaluateExpression).toNot(predicate)
                done()
            }
        }
    }

    private func evaluateExpression() throws -> Value? {
        try self.expression.evaluate()
    }
}

/// A Nimble matcher that succeeds when the actual sequence and the exepected sequence contain the same elements even
/// if they are not in the same order.
public func elementsEqualOrderAgnostic<Col1: Collection, Col2: Collection>(
    _ expectedValue: Col2?
) -> Nimble.Matcher<Col1> where Col1.Element: Equatable, Col1.Element == Col2.Element {
    return Matcher.define("elementsEqualOrderAgnostic <\(stringify(expectedValue))>") { (actualExpression, msg) in
        let actualValue = try actualExpression.evaluate()
        switch (expectedValue, actualValue) {
        case (nil, _?):
            return MatcherResult(status: .fail, message: msg.appendedBeNilHint())
        case (nil, nil), (_, nil):
            return MatcherResult(status: .fail, message: msg)
        case (let expected?, let actual?):
            let matches = expected.count == actual.count && expected.allSatisfy { actual.contains($0) }
            return MatcherResult(bool: matches, message: msg)
        }
    }
}
