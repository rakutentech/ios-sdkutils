import Foundation
import Quick
import Nimble
#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
#endif

// MARK: - AnalyticsBroadcasterSpec

final class AnalyticsBroadcasterSpec: QuickSpec {

    final class AnalyticsTrackerMock {
        private(set) var eventName: String?
        private(set) var params: [String: Any]?

        func trackEvent(name: String, parameters: [String: Any]?) {
            eventName = name
            params = parameters
        }
    }

    override func spec() {
        describe("sendEventName") {
            var tracker: AnalyticsTrackerMock?
            var observer: NSObjectProtocol?

            beforeEach {
                tracker = AnalyticsTrackerMock()
                observer = NotificationCenter.default.addObserver(forName: .sdkCustomEvent,
                                                                  object: nil,
                                                                  queue: OperationQueue()) { notification in
                    tracker?.trackEvent(name: NSNotification.Name.sdkCustomEvent.rawValue, parameters: notification.object as? [String: Any])
                    if let observer = observer {
                        NotificationCenter.default.removeObserver(observer)
                    }
                }
            }

            it("should track sdkCustomEvent with eventName and eventData when an event is broadcasted with data") {
                AnalyticsBroadcaster.sendEventName("blah", dataObject: ["foo": "bar"])

                expect(tracker?.eventName).toEventually(equal(NSNotification.Name.sdkCustomEvent.rawValue))
                expect(tracker?.params?["eventName"] as? String).to(equal("blah"))
                expect(tracker?.params?["eventData"] as? [String: String]).to(equal(["foo": "bar"]))
            }

            it("should track sdkCustomEvent with eventName and no eventData when an event is broadcasted without data") {
                AnalyticsBroadcaster.sendEventName("blah", dataObject: nil)

                expect(tracker?.eventName).toEventually(equal(NSNotification.Name.sdkCustomEvent.rawValue))
                expect(tracker?.params?["eventName"] as? String).to(equal("blah"))
                expect(tracker?.params?["eventData"]).to(beNil())
            }

            it("should not send `customAccNumber` if customAccountNumber is nil") {
                AnalyticsBroadcaster.sendEventName("blah", dataObject: nil, customAccountNumber: nil)

                expect(tracker?.eventName).toEventually(equal(NSNotification.Name.sdkCustomEvent.rawValue))
                expect(tracker?.params?["customAccValue"]).to(beNil())
            }

            it("should send customAccountNumber parameter value as `customAccNumber`") {
                AnalyticsBroadcaster.sendEventName("blah", dataObject: nil, customAccountNumber: 5)

                expect(tracker?.eventName).toEventually(equal(NSNotification.Name.sdkCustomEvent.rawValue))
                expect(tracker?.params?["customAccNumber"] as? NSNumber).to(equal(5))
            }
        }
    }
}
