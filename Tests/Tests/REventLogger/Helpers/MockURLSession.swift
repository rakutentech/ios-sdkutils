import Foundation

#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
@testable import REventLogger
#endif

final class MockURLSessionDataTask: DataTaskProtocol {
    func cancel() {
    }

    private (set) var resumeWasCalled = false
    func resume() {
        resumeWasCalled = true
    }
}

final class MockURLSession: URLSessionProtocol {
    private(set) var dataObj: Data?
    private(set) var jsonObj: Any?
    private(set) var serverErrorCode: Int?
    private(set) var error: NSError?
    private(set) var mockDataTask = MockURLSessionDataTask()
    private(set) var receivedRequest: URLRequest?

    init(json: Any? = nil,
         statusCode: Int = 200,
         error: NSError? = nil) {
        self.jsonObj = json
        self.serverErrorCode = statusCode
        self.error = error
    }

    func createURLSessionDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> DataTaskProtocol {
        receivedRequest = request
        let response = HTTPURLResponse(url: URL(string: "https://test.com")!,
                                       statusCode: serverErrorCode ?? 0,
                                       httpVersion: "1",
                                       headerFields: nil)
        var data: Data?
        if let json = jsonObj {
            data = try? JSONSerialization.data(withJSONObject: json, options: [])
        }
        completionHandler(data, response, error)
        return mockDataTask
    }
}
