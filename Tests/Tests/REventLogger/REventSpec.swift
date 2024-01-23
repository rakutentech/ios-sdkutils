import Quick
import Nimble
import Foundation

#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
@testable import REventLogger
#endif

class REventsSpec: QuickSpec {
    override func spec() {
        describe("REvent") {
                it("will generate identifier using the event fields") {
                    let event = REvent(.warning, sdkName: "IAM",
                                       sdkVersion: "8.0,0", errorCode: "500",
                                       errorMessage: "Network Error", info: nil)
                    expect(event.eventId).to(equal("warning_1.0_iam_500_network_error"))
                }
                it("will increase the occurence count of event") {
                    var event = REvent(.warning, sdkName: "PNP",
                                       sdkVersion: "8.0,0", errorCode: "500",
                                       errorMessage: "Network Error", info: nil)
                    event.updateOccurrenceCount()
                    expect(event.occurrenceCount).to(equal(2))
                }
                it("will update the eventtype") {
                    var event = REvent(.warning, sdkName: "Pitari",
                                       sdkVersion: "4.1.0", errorCode: "500",
                                       errorMessage: "Network", info: nil)
                    event.updateEventType(type: .critical)
                    expect(event.eventType.rawValue).to(equal("critical"))
                }
        }
    }
}
