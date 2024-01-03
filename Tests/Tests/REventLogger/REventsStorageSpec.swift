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
        let userDefaults = UserDefaults(suiteName: "REventsStorageSpec")!

        afterEach {
            UserDefaults.standard.removePersistentDomain(forName: "REventsStorageSpec")
        }

        describe("REvents Logger Storage ") {
            context("getAllEvents method") {
                it("will return empty array if no cached data was found") {
                    let eventCache = EventDataCache(userDefaults: userDefaults)
                    expect(eventCache.getAllEvents()).to(equal([]))
                    expect(eventCache.getEventCount()).to(equal(0))
                }
                it("will return array of Events if cached data is avaialble") {
                    let eventCache = EventDataCache(userDefaults: userDefaults)
                    let eventId = EVentLoggerMockData.REventModel.getEventIdentifier()
                    eventCache.insertOrUpdateEvent(eventId, event: EVentLoggerMockData.REventModel)
                    expect(eventCache.getEventCount()).to(equal(1))
                    expect((eventCache.getAllEvents()).count).to(equal(1))
                }
            }
            context("Retrive Event method ") {
                it("will retrieve events for the event id") {
                    let eventCache = EventDataCache(userDefaults: userDefaults)
                    let eventId = EVentLoggerMockData.REventModel.getEventIdentifier()
                    eventCache.insertOrUpdateEvent(eventId, event: EVentLoggerMockData.REventModel)
                    expect(eventCache.getEventCount()).to(equal(1))
                    let event = eventCache.retriveEvent(eventId)
                    expect(event).to(equal(EVentLoggerMockData.REventModel))
                }
            }
            context("Delete Events method ") {
                it("will delete events for ") {
                    let eventCache = EventDataCache(userDefaults: userDefaults)
                    let eventId = EVentLoggerMockData.REventModel.getEventIdentifier()
                    eventCache.insertOrUpdateEvent(eventId, event: EVentLoggerMockData.REventModel)
                    eventCache.deleteEvents([eventId])
                    expect(eventCache.getEventCount()).to(equal(0))
                }
            }
            context("Delete Old Events method ") {
                it("will not delete old events the number of events in cache is equal  or less than max  capacity ") {
                    let eventCache = EventDataCache(userDefaults: userDefaults)
                    let eventId1 = EVentLoggerMockData.REventModel.getEventIdentifier()
                    let eventId2 = EVentLoggerMockData.REventModel1.getEventIdentifier()
                    let eventId3 = EVentLoggerMockData.REventModel2.getEventIdentifier()
                    eventCache.insertOrUpdateEvent(eventId1, event: EVentLoggerMockData.REventModel)
                    eventCache.insertOrUpdateEvent(eventId2, event: EVentLoggerMockData.REventModel1)
                    eventCache.insertOrUpdateEvent(eventId3, event: EVentLoggerMockData.REventModel2)
                    eventCache.deleteOldEvents(maxCapacity: 3)
                    expect(eventCache.getEventCount()).to(equal(3))
                }
                it("will delete old events if it reaches max capacity") {
                    let eventCache = EventDataCache(userDefaults: userDefaults)
                    let eventId1 = EVentLoggerMockData.REventModel.getEventIdentifier()
                    let eventId2 = EVentLoggerMockData.REventModel1.getEventIdentifier()
                    let eventId3 = EVentLoggerMockData.REventModel2.getEventIdentifier()
                    eventCache.insertOrUpdateEvent(eventId1, event: EVentLoggerMockData.REventModel)
                    eventCache.insertOrUpdateEvent(eventId2, event: EVentLoggerMockData.REventModel1)
                    eventCache.insertOrUpdateEvent(eventId3, event: EVentLoggerMockData.REventModel2)
                    eventCache.deleteOldEvents(maxCapacity: 1)
                    expect(eventCache.getEventCount()).to(equal(1))
                    expect(eventCache.retriveEvent(eventId3)).to(equal(EVentLoggerMockData.REventModel2))
                }
            }
        }
    }
}
