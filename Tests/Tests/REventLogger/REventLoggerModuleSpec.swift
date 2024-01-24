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
            var mockEventsSender: REventSenderMock!
            var mockEventStorage: REventStorageMock!
            var mockEventsCache: REventsLoggerCacheMock!
            var eventLoggerModule: REventLoggerModule!
            var mockAppLifeCycleListener: AppLifeCycleManagerMock!
            beforeEach {
                mockEventsSender = REventSenderMock()
                mockEventStorage = REventStorageMock()
                mockEventsCache = REventsLoggerCacheMock()
                mockAppLifeCycleListener = AppLifeCycleManagerMock()
                mockEventsSender.response = .success(Data())
                eventLoggerModule = REventLoggerModule(eventsStorage: mockEventStorage,
                                                       eventsSender: mockEventsSender,
                                                       eventsCache: mockEventsCache,
                                                       appLifeCycleListener: mockAppLifeCycleListener)
            }
            context("isEventValid method") {
                it("will return true for a valid event") {
                    let isvalid = eventLoggerModule.isEventValid("IAM", "7.2.0", "500", "Network Error")
                    expect(isvalid).to(beTrue())
                }
                it("will return false for an invalid event with empty values") {
                    let isvalid = eventLoggerModule.isEventValid("", "", "", "")
                    expect(isvalid).toNot(beTrue())
                }
            }

            context("sendCriticalEvent method") {
                it("will store the critical event as a warning event after sending the event") {
                    let event = REventLoggerMockData.REventModel
                    waitUntil { done in
                        eventLoggerModule.sendCriticalEvent(event.eventId, event)
                        expect(mockEventStorage.getEventCount()).to(equal(1))
                        let storedEvent = mockEventStorage.retrieveEvent(event.eventId)
                        expect(storedEvent?.eventType.rawValue).to(equal("1"))
                        done()
                    }
                }
            }

            context("sendAllEventsInStorage method") {
                it("will delete all the stored events after sending the events") {
                    mockEventStorage.insertOrUpdateEvent("event1", event: REventLoggerMockData.REventModel)
                    mockEventStorage.insertOrUpdateEvent("event2", event: REventLoggerMockData.REventModel2)
                    waitUntil { done in
                        expect(mockEventStorage.getEventCount()).to(equal(2))
                        eventLoggerModule.sendAllEventsInStorage(deleteOldEventsOnFailure: true)
                        expect(mockEventStorage.getEventCount()).to(equal(0))
                        done()
                    }
                }
            }
            context("sendEventIfNeeded method") {
                it("will send the critical event if new critical event is logged and store it as warning event") {
                    waitUntil { done in
                        let event = REventLoggerMockData.REventModel
                        eventLoggerModule.sendEventIfNeeded(.critical, event.eventId, event, true)
                        expect(mockEventStorage.getEventCount()).to(equal(1))
                        let storedEvent = mockEventStorage.retrieveEvent(event.eventId)
                        expect(storedEvent?.eventType.rawValue).to(equal("1"))
                        done()
                    }
                }
                it("will send all the events in storage and delete all the stored events if the max capacity is reached") {
                    waitUntil { done in
                        mockEventStorage.insertOrUpdateEvent("event1", event: REventLoggerMockData.REventModel)
                        mockEventStorage.insertOrUpdateEvent("event2", event: REventLoggerMockData.REventModel2)
                        let newEvent = REventLoggerMockData.REventModel
                        eventLoggerModule.sendEventIfNeeded(.critical, newEvent.eventId, newEvent, true, maxEventCount: 2)
                        expect(mockEventStorage.getEventCount()).to(equal(0))
                        done()
                    }
                }
            }
            context("isTtlExpired method") {
                it("will return true if the diffence between current time and reference time is more than ttl expiry time") {
                    mockEventsCache.setTtlReferenceTime(REventLoggerMockData.mockRefTime)
                    expect(eventLoggerModule.isTtlExpired()).to(equal(true))
                }
                it("will return false if the diffence between current time and reference time is less than ttl expiry time") {
                    mockEventsCache.setTtlReferenceTime(REventLoggerMockData.mockRefTime2)
                    expect(eventLoggerModule.isTtlExpired()).to(equal(false))
                }
            }
            context("configure method") {
                it("will configure the api key and api url if valid value is sent") {
                    eventLoggerModule.configure(apiConfiguration: EventLoggerConfiguration(apiKey: REventLoggerMockData.apiKey,
                                                                                           apiUrl: REventLoggerMockData.apiUrl))
                    expect(mockEventsSender.didConfigure).to(beTrue())
                }
                it("will not configure api Key and url if valid values is not sent") {
                    eventLoggerModule.configure(apiConfiguration: nil)
                    expect(mockEventsSender.didConfigure).to(beFalse())
                }
            }

            describe("when app became active") {
                context("should send all stored events & delete all once send") {
                    beforeEach {
                        mockEventStorage.insertOrUpdateEvent("event1", event: REventLoggerMockData.REventModel)
                        mockEventStorage.insertOrUpdateEvent("event2", event: REventLoggerMockData.REventModel2)
                    }
                    it("if ttl is expired") {
                        mockEventsCache.setTtlReferenceTime(Date.yesterday!.timeInMilliseconds)
                        expect(mockEventStorage.getEventCount()).to(equal(2))
                        mockAppLifeCycleListener.postDidBecomeActiveNotification()
                        expect(mockEventStorage.getEventCount()).toEventually(equal(0), timeout: .seconds(2))
                    }
                }

                context("should not send all stored events") {
                    beforeEach {
                        mockEventStorage.insertOrUpdateEvent("event1", event: REventLoggerMockData.REventModel)
                        mockEventStorage.insertOrUpdateEvent("event2", event: REventLoggerMockData.REventModel2)
                    }
                    it("if ttl is not expired") {
                        mockEventsCache.setTtlReferenceTime(Date().timeInMilliseconds)
                        expect(mockEventStorage.getEventCount()).to(equal(2))
                        mockAppLifeCycleListener.postDidBecomeActiveNotification()
                        expect(mockEventStorage.getEventCount()).toEventually(equal(2), timeout: .seconds(2))
                    }
                }
            }
        }
    }
}

extension Date {
    static let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
}
