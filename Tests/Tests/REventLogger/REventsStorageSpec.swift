import Quick
import Nimble
import Foundation

#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
@testable import REventLogger
#endif

class REventsStorageSpec: QuickSpec {
    override func spec() {
        var eventCache = EventDataCache(userDefaults: UserDefaults())
        beforeEach {
            let userDefaults = UserDefaults(suiteName: "REventsStorageSpec")!
            eventCache = EventDataCache(userDefaults: userDefaults)
        }
        afterEach {
            UserDefaults.standard.removePersistentDomain(forName: "REventsStorageSpec")
        }

        describe("REvents Logger Storage ") {
            context("getAllEvents method") {
                it("will return empty array if no cached data was found") {
                    expect(eventCache.getAllEvents()).to(equal([]))
                    expect(eventCache.getEventCount()).to(equal(0))
                }
                it("will return array of Events if cached data is avaialble") {
                    let eventId = REventLoggerMockData.REventModel.eventId
                    eventCache.insertOrUpdateEvent(eventId, event: REventLoggerMockData.REventModel)
                    expect(eventCache.getEventCount()).to(equal(1))
                    expect((eventCache.getAllEvents()).count).to(equal(1))
                }
            }
            context("Retrive Event method ") {
                it("will retrieve events for the event id") {
                    let eventId = REventLoggerMockData.REventModel.eventId
                    eventCache.insertOrUpdateEvent(eventId, event: REventLoggerMockData.REventModel)
                    expect(eventCache.getEventCount()).to(equal(1))
                    let event = eventCache.retriveEvent(eventId)
                    expect(event).to(equal(REventLoggerMockData.REventModel))
                }
            }
            context("Delete Events method ") {
                it("will delete events for ") {
                    let eventId = REventLoggerMockData.REventModel.eventId
                    eventCache.insertOrUpdateEvent(eventId, event: REventLoggerMockData.REventModel)
                    eventCache.deleteEvents([eventId])
                    expect(eventCache.getEventCount()).to(equal(0))
                }
            }
            context("Delete Old Events method ") {
                it("will not delete old events if the number of events in cache is equal or less than max capacity") {
                    let eventId1 = REventLoggerMockData.REventModel.eventId
                    let eventId2 = REventLoggerMockData.REventModel1.eventId
                    let eventId3 = REventLoggerMockData.REventModel2.eventId
                    eventCache.insertOrUpdateEvent(eventId1, event: REventLoggerMockData.REventModel)
                    eventCache.insertOrUpdateEvent(eventId2, event: REventLoggerMockData.REventModel1)
                    eventCache.insertOrUpdateEvent(eventId3, event: REventLoggerMockData.REventModel2)
                    eventCache.deleteOldEvents(maxCapacity: 3)
                    expect(eventCache.getEventCount()).to(equal(3))
                }
                it("will delete old events if the number of events in cache exceeds max capacity") {
                    let eventId1 = REventLoggerMockData.REventModel.eventId
                    let eventId2 = REventLoggerMockData.REventModel1.eventId
                    let eventId3 = REventLoggerMockData.REventModel2.eventId
                    eventCache.insertOrUpdateEvent(eventId1, event: REventLoggerMockData.REventModel)
                    eventCache.insertOrUpdateEvent(eventId2, event: REventLoggerMockData.REventModel1)
                    eventCache.insertOrUpdateEvent(eventId3, event: REventLoggerMockData.REventModel2)
                    eventCache.deleteOldEvents(maxCapacity: 1)
                    expect(eventCache.getEventCount()).to(equal(1))
                    expect(eventCache.retriveEvent(eventId3)).to(equal(REventLoggerMockData.REventModel2))
                }
            }
        }
    }
}
