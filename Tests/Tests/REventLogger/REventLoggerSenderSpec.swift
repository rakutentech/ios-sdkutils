import Quick
import Nimble
import Foundation

#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import REventLogger
#endif

class REventLoggerSenderSpec: QuickSpec {
    override func spec() {
        describe("REvent Logger Sender") {
            context("when network response has success status code") {
                it("it will get valid response") {
                    let mockResponse: [String: Any] = [:]
                    let mockSession = MockURLSession(json: mockResponse)
                    var eventSender = REventLoggerSender(networkManager: NetworkManager(session: mockSession),
                                                         eventsList: [EVentLoggerMockData.REventModel])
                    waitUntil { done in
                        eventSender.sendEvents("https://testURL.com") { result in
                            guard case .success(let data) = result else {
                                fail()
                                return
                            }
                            expect(data.isEmpty).to(beFalse())
                            done()
                        }
                    }
                }
            }

            context("when network response has error") {
                it("will receive bad request error") {
                    let mockSession = MockURLSession(statusCode: 400)
                    var eventSender = REventLoggerSender(networkManager: NetworkManager(session: mockSession),
                                                         eventsList: [EVentLoggerMockData.REventModel])
                    waitUntil { done in
                        eventSender.sendEvents("https://testURL.com") { result in
                            guard case .failure(let error) = result else {
                                fail()
                                return
                            }
                            expect((error as NSError).code).to(equal(400))
                            expect((error as NSError).localizedDescription).to(equal("Unspecified server error occurred."))
                            done()
                        }
                    }
                }

                it("will receive response data nil error") {
                    let mockSession = MockURLSession()
                    var eventSender = REventLoggerSender(networkManager: NetworkManager(session: mockSession),
                                                         eventsList: [EVentLoggerMockData.REventModel])
                    waitUntil { done in
                        eventSender.sendEvents("https://testURL.com") { result in
                            guard case .failure(let error) = result else {
                                fail()
                                return
                            }
                            expect(error.localizedDescription).to(equal("Response data is nil"))
                            done()
                        }
                    }
                }

                it("will receive invalid url error") {
                    let mockSession = MockURLSession()
                    var eventSender = REventLoggerSender(networkManager: NetworkManager(session: mockSession),
                                                         eventsList: [EVentLoggerMockData.REventModel])
                    waitUntil { done in
                        eventSender.sendEvents("") { result in
                            guard case .failure(let error) = result else {
                                fail()
                                return
                            }
                            expect(error.localizedDescription).to(equal("URL is invalid"))
                            done()
                        }
                    }
                }
            }
        }
    }
}
