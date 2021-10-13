import Foundation
import Quick
import Nimble
#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
#endif

class URLSessionExtensionsSpec: QuickSpec {

    override func spec() {

        describe("URLSessionExtensions") {

            context("Sessionable URLSession extension") {

                let session = URLSession.shared

                it("createDataTask() will properly create URLSessionTask object") {
                    let request = URLRequest(url: URL(string: "http://localhost")!)
                    let dataTask = session.createDataTask(with: request, completionHandler: { _, _, _ in })
                    expect(dataTask).to(beAKindOf(URLSessionTask.self))
                    expect((dataTask as? URLSessionTask)?.currentRequest).to(equal(request))
                }
            }

            context("SwiftySessionable default implementation") {

                let session = SwiftySessionableMock()

                it("will properly map completion handler - success") {
                    let request = URLRequest(url: URL(string: "http://localhost")!)
                    let expectedData = "data".data(using: .ascii)!
                    let expectedResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
                    waitUntil { done in
                        _ = session.dataTask(with: request) { result in
                            let resultData = try? result.get()
                            expect(result).toNot(beNil())
                            expect(resultData?.data).to(equal(expectedData))
                            expect(resultData?.response).to(equal(expectedResponse))
                            done()
                        }
                        session.callCompletionHandler?(expectedData, expectedResponse, nil)
                    }
                }

                it("will properly map completion handler - error") {
                    let request = URLRequest(url: URL(string: "http://localhost")!)
                    let expectedError = NSError(domain: "test", code: 5, userInfo: nil)
                    waitUntil { done in
                        _ = session.dataTask(with: request) { result in
                            if case let .failure(error) = result {
                                expect(error as NSError).to(equal(expectedError))
                            } else {
                                fail()
                            }
                            done()
                        }
                        session.callCompletionHandler?(nil, nil, expectedError)
                    }
                }

                it("will throw an assertion if there was no error but there's no response object") {
                    let request = URLRequest(url: URL(string: "http://localhost")!)
                    let expectedData = "data".data(using: .ascii)!
                    _ = session.dataTask(with: request) { _ in }
                    expect(session.callCompletionHandler?(expectedData, nil, nil)).to(throwAssertion())
                }
            }
        }
    }
}

private class SwiftySessionableMock: URLSession {
    private(set) var callCompletionHandler: ((_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void)?

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.callCompletionHandler = completionHandler
        return URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    }
}
