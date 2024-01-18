import Quick
import Nimble
import Foundation

#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
@testable import REventLogger
#endif

class REventLoggerModuleSpec: QuickSpec {
    override func spec() {
        describe("Event Logger Module") {
            var eventsSender: REventSenderMock!
            var eventStorage: REventStorageMock!
            var eventsCache: REventsLoggerCacheMock!
            var eventLoggerModule: REventLoggerModule!
            beforeEach {
            eventsSender = REventSenderMock()
            eventStorage = REventStorageMock()
            eventsCache = REventsLoggerCacheMock()
            eventLoggerModule = REventLoggerModule(eventsStorage: eventStorage,
                                                   eventsSender: eventsSender,
                                                   eventsCache: eventsCache)
            }
            context("isEventValid method") {
                it("will return true for a valid event") {
                    let isvalid = eventLoggerModule.isEventValid("IAM", "7.2.0", "500", "Network Error")
                }
                it("will return false for a valid event") {
                    let isvalid = eventLoggerModule.isEventValid("", "", "", "")
                }
            }
        }
    }
}
