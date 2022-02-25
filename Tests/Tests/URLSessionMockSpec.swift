import Foundation
import Quick
import Nimble
#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
@testable import RSDKUtilsTestHelpers
#endif

final class URLSessionMockSpec: QuickSpec {

    override func spec() {
        describe("URLSessionMock") {

            var originalSession: URLSession!
            var sessionMock: URLSessionMock!

            beforeEach {
                originalSession = URLSession(configuration: .ephemeral)
                sessionMock = URLSessionMock.mock(originalInstance: originalSession)
            }

            it("should return the same mock instance for the same url session") {
                expect(URLSessionMock.mock(originalInstance: originalSession)).to(beIdenticalTo(sessionMock))
            }

            it("should use originalSession if startMockingURLSession() was not called") {
                sessionMock.httpResponse = HTTPURLResponse(url: URL(string: "some.url")!,
                                                           statusCode: 500,
                                                           httpVersion: nil,
                                                           headerFields: nil)
                waitUntil { done in
                    originalSession.dataTask(with: URLRequest(url: URL(string: "about:blank")!)) { _, response, _ in
                        expect(response?.url?.absoluteString).to(equal("about:blank"))
                        expect(response).toNot(beAKindOf(HTTPURLResponse.self))
                        done()
                    }.resume()
                }
                expect(sessionMock.sentRequest).to(beNil())
            }

            it("should use originalSession if stopMockingURLSession() was called") {
                URLSessionMock.startMockingURLSession()
                sessionMock.httpResponse = HTTPURLResponse(url: URL(string: "some.url")!,
                                                           statusCode: 500,
                                                           httpVersion: nil,
                                                           headerFields: nil)
                URLSessionMock.stopMockingURLSession()
                waitUntil { done in
                    originalSession.dataTask(with: URLRequest(url: URL(string: "about:blank")!)) { _, response, _ in
                        expect(response?.url?.absoluteString).to(equal("about:blank"))
                        expect(response).toNot(beAKindOf(HTTPURLResponse.self))
                        done()
                    }.resume()
                }
                expect(sessionMock.sentRequest).to(beNil())
            }

            context("when startMockingURLSession() was called") {
                beforeEach {
                    URLSessionMock.startMockingURLSession()
                }

                it("should return mocked values in dataTask completion") {
                    let expectedResponse = HTTPURLResponse(url: URL(string: "some.url")!,
                                                           statusCode: 500,
                                                           httpVersion: nil,
                                                           headerFields: nil)
                    let expectedError = NSError(domain: "mock.domain", code: 1234, userInfo: ["user": "info"])
                    let expectedData = "data".data(using: .utf8)
                    sessionMock.httpResponse = expectedResponse
                    sessionMock.responseError = expectedError
                    sessionMock.responseData = expectedData

                    waitUntil { done in
                        originalSession.dataTask(with: URLRequest(url: URL(string: "https://google.com")!)) { data, response, error in
                            expect(data).to(equal(expectedData))
                            expect(error as NSError?).to(equal(expectedError))
                            expect(response).to(equal(expectedResponse))
                            done()
                        }.resume()
                    }
                }

                it("should call onCompletedTask when the task is finished") {
                    var onCompletedTaskCalled = false
                    sessionMock.onCompletedTask = {onCompletedTaskCalled = true }
                    waitUntil { done in
                        originalSession.dataTask(with: URLRequest(url: URL(string: "https://google.com")!)) { _, _, _ in
                            done()
                        }.resume()
                    }

                    expect(onCompletedTaskCalled).to(beTrue())
                }

                it("should keep a copy of last URLRequest in `sentRequest` var") {
                    let request = URLRequest(url: URL(string: "https://google.com")!)
                    expect(sessionMock.sentRequest).to(beNil())
                    waitUntil { done in
                        originalSession.dataTask(with: request) { _, _, _ in
                            done()
                        }.resume()
                    }

                    expect(sessionMock.sentRequest).toNot(beNil())
                    expect(sessionMock.sentRequest).to(equal(request))
                }

                context("when calling decodeSentData()") {

                    it("should succeed if all expected parameters are present") {
                        let jsonData = """
                        {"identifier":100, "isTest":true, "appVersion":"1.2.3", "sdkVersion":"0.0.5"}
                        """.data(using: .utf8)!

                        var request = URLRequest(url: URL(string: "https://google.com")!)
                        request.httpBody = jsonData
                        waitUntil { done in
                            originalSession.dataTask(with: request) { _, _, _ in
                                done()
                            }.resume()
                        }

                        let decodedModel = sessionMock.decodeSentData(modelType: BodyModel.self)
                        expect(decodedModel).toNot(beNil())
                        expect(decodedModel?.identifier).to(equal(100))
                        expect(decodedModel?.isTest).to(beTrue())
                        expect(decodedModel?.appVersion).to(equal("1.2.3"))
                        expect(decodedModel?.sdkVersion).to(equal("0.0.5"))
                    }

                    it("should succeed if there are optional parameters in the json") {
                        let jsonData = """
                        {"identifier":100, "isTest":true, "appVersion":"1.2.3", "sdkVersion":"0.0.5", "locale":"pl"}
                        """.data(using: .utf8)!

                        var request = URLRequest(url: URL(string: "https://google.com")!)
                        request.httpBody = jsonData
                        waitUntil { done in
                            originalSession.dataTask(with: request) { _, _, _ in
                                done()
                            }.resume()
                        }

                        let decodedModel = sessionMock.decodeSentData(modelType: BodyModel.self)
                        expect(decodedModel).toNot(beNil())
                        expect(decodedModel?.identifier).to(equal(100))
                        expect(decodedModel?.isTest).to(beTrue())
                        expect(decodedModel?.appVersion).to(equal("1.2.3"))
                        expect(decodedModel?.sdkVersion).to(equal("0.0.5"))
                    }

                    it("should fail if not all expected parameters are present") {
                        let jsonData = """
                        {"identifier":100, "isTest":true, "appVersion":"1.2.3"}
                        """.data(using: .utf8)!

                        var request = URLRequest(url: URL(string: "https://google.com")!)
                        request.httpBody = jsonData
                        waitUntil { done in
                            originalSession.dataTask(with: request) { _, _, _ in
                                done()
                            }.resume()
                        }

                        let decodedModel = sessionMock.decodeSentData(modelType: BodyModel.self)
                        expect(decodedModel).to(beNil())
                    }

                    it("should fail if parameter type does not match") {
                        let jsonData = """
                        {"identifier":"id", "isTest":true, "appVersion":"1.2.3", "sdkVersion":"0.0.5"}
                        """.data(using: .utf8)!

                        var request = URLRequest(url: URL(string: "https://google.com")!)
                        request.httpBody = jsonData
                        waitUntil { done in
                            originalSession.dataTask(with: request) { _, _, _ in
                                done()
                            }.resume()
                        }

                        let decodedModel = sessionMock.decodeSentData(modelType: BodyModel.self)
                        expect(decodedModel).to(beNil())
                    }
                }

                context("when calling decodeQueryItems()") {

                    it("should succeed if all expected parameters are present") {
                        let urlQuery = URL(string: "http://config.url?isTest=true&identifier=100&appVersion=1.2.3&sdkVersion=0.0.5")!

                        waitUntil { done in
                            originalSession.dataTask(with: URLRequest(url: urlQuery)) { _, _, _ in
                                done()
                            }.resume()
                        }
                        let decodedModel = sessionMock.decodeQueryItems(modelType: URLQueryModel.self)
                        expect(decodedModel).toNot(beNil())
                        expect(decodedModel?.identifier).to(equal(100))
                        expect(decodedModel?.isTest).to(beTrue())
                        expect(decodedModel?.appVersion).to(equal("1.2.3"))
                        expect(decodedModel?.sdkVersion).to(equal("0.0.5"))
                    }

                    it("should succeed if there are optional parameters in the url") {
                        let urlQuery = URL(string: "http://config.url?isTest=true&identifier=100&appVersion=1.2.3&sdkVersion=0.0.5&locale=pl")!

                        waitUntil { done in
                            originalSession.dataTask(with: URLRequest(url: urlQuery)) { _, _, _ in
                                done()
                            }.resume()
                        }
                        let decodedModel = sessionMock.decodeQueryItems(modelType: URLQueryModel.self)
                        expect(decodedModel).toNot(beNil())
                        expect(decodedModel?.identifier).to(equal(100))
                        expect(decodedModel?.isTest).to(beTrue())
                        expect(decodedModel?.appVersion).to(equal("1.2.3"))
                        expect(decodedModel?.sdkVersion).to(equal("0.0.5"))
                    }

                    it("should fail if not all expected parameters are present") {
                        let urlQuery = URL(string: "http://config.url?isTest=true&identifier=100&appVersion=1.2.3")!

                        waitUntil { done in
                            originalSession.dataTask(with: URLRequest(url: urlQuery)) { _, _, _ in
                                done()
                            }.resume()
                        }
                        let decodedModel = sessionMock.decodeQueryItems(modelType: URLQueryModel.self)
                        expect(decodedModel).to(beNil())
                    }

                    it("should fail if parameter type does not match") {
                        let urlQuery = URL(string: "http://config.url?isTest=true&identifier=id&appVersion=1.2.3&sdkVersion=0.0.5")!

                        waitUntil { done in
                            originalSession.dataTask(with: URLRequest(url: urlQuery)) { _, _, _ in
                                done()
                            }.resume()
                        }
                        let decodedModel = sessionMock.decodeQueryItems(modelType: URLQueryModel.self)
                        expect(decodedModel).to(beNil())
                    }
                }
            }
        }
    }
}

internal struct URLQueryModel: Codable {
    let identifier: Int
    let isTest: Bool
    let appVersion: String
    let sdkVersion: String
}

private struct BodyModel: Codable {
    let identifier: Int
    let isTest: Bool
    let appVersion: String
    let sdkVersion: String
}
