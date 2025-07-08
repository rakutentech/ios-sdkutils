import Quick
import Nimble
import Foundation

#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
@testable import REventLogger
#endif

class REventLoggerSenderSpec: QuickSpec {
    override func spec() {
        describe("REvent Logger Sender") {
            context("when network response has success status code") {
                it("it will get valid response") {
                    let mockResponse: [String: Any] = [:]
                    let eventSender = REventLoggerSender(networkManager: NetworkManager(session: MockURLSession(json: mockResponse)))
                    eventSender.updateApiConfiguration(EventLoggerConfiguration(apiKey: REventLoggerMockData.apiKey,
                                                                                apiUrl: REventLoggerMockData.apiUrl, appGroupId: nil))
                    waitUntil { done in
                        eventSender.sendEvents(events: [REventLoggerMockData.REventModel, REventLoggerMockData.REventModel1],
                                               onCompletion: { result in
                            guard case .success(let data) = result else {
                                fail()
                                return
                            }
                            expect(data.isEmpty).to(beFalse())
                            done()
                        })
                    }
                }
            }

            context("when network response has error") {
                it("will receive bad request error") {
                    let eventSender = REventLoggerSender(networkManager: NetworkManager(session: MockURLSession(statusCode: 400)))
                    eventSender.updateApiConfiguration(EventLoggerConfiguration(apiKey: REventLoggerMockData.apiKey,
                                                                                apiUrl: REventLoggerMockData.apiUrl, appGroupId: nil))
                    waitUntil { done in
                        eventSender.sendEvents(events: [REventLoggerMockData.REventModel], onCompletion: { result in
                            guard case .failure(let error) = result else {
                                fail()
                                return
                            }
                            expect((error as NSError).code).to(equal(400))
                            expect((error as NSError).localizedDescription).to(equal("Unspecified server error occurred."))
                            done()
                        })
                    }
                }

                it("will receive response data nil error") {
                    let eventSender = REventLoggerSender(networkManager: NetworkManager(session: MockURLSession()))
                    eventSender.updateApiConfiguration(EventLoggerConfiguration(apiKey: REventLoggerMockData.apiKey,
                                                                                apiUrl: REventLoggerMockData.apiUrl, appGroupId: nil))
                    waitUntil { done in
                        eventSender.sendEvents(events: [REventLoggerMockData.REventModel1], onCompletion: { result in
                            guard case .failure(let error) = result else {
                                fail()
                                return
                            }
                            expect(error.localizedDescription).to(equal("Response data is nil"))
                            done()
                        })
                    }
                }

                it("will receive invalid url error") {
                    let eventSender = REventLoggerSender(networkManager: NetworkManager(session: MockURLSession()))
                    eventSender.updateApiConfiguration(EventLoggerConfiguration(apiKey: REventLoggerMockData.apiKey,
                                                                                apiUrl: "", appGroupId: nil))
                    waitUntil { done in
                        eventSender.sendEvents(events: [REventLoggerMockData.REventModel2], onCompletion: { result in
                            guard case .failure(let error) = result else {
                                fail()
                                return
                            }
                            expect(error.localizedDescription).to(equal("URL is invalid"))
                            done()
                        })
                    }
                }

                it("will not retry for error code 500") {
                    let eventSender = REventLoggerSender(networkManager: NetworkManager(session: MockURLSession(statusCode: 500)))
                    eventSender.updateApiConfiguration(EventLoggerConfiguration(apiKey: REventLoggerMockData.apiKey,
                                                                                apiUrl: REventLoggerMockData.apiUrl, appGroupId: nil))
                    eventSender.sendEvents(events: [REventLoggerMockData.REventModel2], onCompletion: { _ in})
                    expect(eventSender.scheduledTask).toAfterTimeout(beNil(), timeout: 0.1)
                }

                it("will retry for notConnectedToInternet error") {
                    let mockSession = MockURLSession(error: URLError(.notConnectedToInternet) as NSError)
                    let eventSender = REventLoggerSender(networkManager: NetworkManager(session: mockSession))
                    eventSender.updateApiConfiguration(EventLoggerConfiguration(apiKey: REventLoggerMockData.apiKey,
                                                                                apiUrl: REventLoggerMockData.apiUrl, appGroupId: nil))
                    eventSender.sendEvents(events: [REventLoggerMockData.REventModel2], onCompletion: { _ in})
                    expect(eventSender.scheduledTask).toEventuallyNot(beNil())
                }

                it("will retry for networkConnectionLost error") {
                    let mockSession = MockURLSession(error: URLError(.networkConnectionLost) as NSError)
                    let eventSender = REventLoggerSender(networkManager: NetworkManager(session: mockSession))
                    eventSender.updateApiConfiguration(EventLoggerConfiguration(apiKey: REventLoggerMockData.apiKey,
                                                                                apiUrl: REventLoggerMockData.apiUrl, appGroupId: nil))
                    eventSender.sendEvents(events: [REventLoggerMockData.REventModel2], onCompletion: { _ in})
                    expect(eventSender.scheduledTask).toEventuallyNot(beNil())
                }
            }
        }
    }
}
