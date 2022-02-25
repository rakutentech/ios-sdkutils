import Foundation
#if canImport(RSDKUtilsMain)
import RSDKUtilsMain
#endif

public final class URLSessionMock: URLSession {

    public typealias SessionTaskCompletion = (Data?, URLResponse?, Error?) -> Void

    private static var swizzledMethods: (Method, Method)?
    private static var mockSessionLinks = [URLSession: WeakWrapper<URLSessionMock>]()

    private let originalInstance: URLSession?

    @objc public var sentRequest: URLRequest?
    public var httpResponse: HTTPURLResponse?
    public var responseData: Data?
    public var responseError: Error?
    public var onCompletedTask: (() -> Void)?

    public static func mock(originalInstance: URLSession) -> URLSessionMock {
        if let existingMock = URLSessionMock.mockSessionLinks[originalInstance]?.value {
            return existingMock
        } else {
            let newMock = URLSessionMock(originalInstance: originalInstance)
            URLSessionMock.mockSessionLinks[originalInstance] = WeakWrapper(value: newMock)
            return newMock
        }
    }

    private init(originalInstance: URLSession) {
        self.originalInstance = originalInstance
        super.init()
    }

    public static func startMockingURLSession() {
        guard swizzledMethods == nil else {
            return
        }

        let originalMethod = class_getInstanceMethod(
            URLSession.self,
            #selector(URLSession().dataTask(with:completionHandler:)
                as (URLRequest, @escaping SessionTaskCompletion) -> URLSessionDataTask))!

        let dummyObject = URLSessionMock(originalInstance: URLSession())
        let swizzledMethod = class_getInstanceMethod(
            URLSessionMock.self,
            #selector(dummyObject.dataTask(with:completionHandler:)
                as (URLRequest, @escaping SessionTaskCompletion) -> URLSessionDataTask))!

        swizzledMethods = (originalMethod, swizzledMethod)
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    public static func stopMockingURLSession() {
        guard let swizzledMethods = swizzledMethods else {
            return
        }
        method_exchangeImplementations(swizzledMethods.0, swizzledMethods.1)
        self.swizzledMethods = nil
    }

    public func decodeSentData<T: Decodable>(modelType: T.Type) -> T? {
        guard let httpBody = sentRequest?.httpBody else {
            return nil
        }
        return try? JSONDecoder().decode(modelType.self, from: httpBody)
    }

    public func decodeQueryItems<T: Decodable>(modelType: T.Type) -> T? {
        guard let url = sentRequest?.url,
              let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = urlComponents.queryItems else {
            return nil
        }
        let array = queryItems.map { item -> String? in
            guard let value = item.value else {
                return nil
            }
            if let boolValue = Bool(value) {
                return "\"\(item.name)\": \(boolValue)"
            }
            if let intValue = Int(value) {
                return "\"\(item.name)\": \(intValue)"
            }
            return "\"\(item.name)\": \"\(value)\""
        }.compactMap { $0 }
        guard let jsonData = "{\(array.joined(separator: ","))}".data(using: .utf8) else {
            return nil
        }
        return try? JSONDecoder().decode(modelType.self, from: jsonData)
    }

    public override func dataTask(
        with request: URLRequest,
        completionHandler: @escaping SessionTaskCompletion) -> URLSessionDataTask {

        let mockedSession: URLSessionMock?
        if self.responds(to: #selector(getter: sentRequest)) {
            mockedSession = self // not swizzled
        } else {
            mockedSession = URLSessionMock.mockSessionLinks[self]?.value
        }

        let originalSession = mockedSession?.originalInstance ?? URLSession.shared
        guard let mockContainer = mockedSession else {
            return originalSession.dataTask(with: request)
        }

        mockContainer.sentRequest = request
        completionHandler(mockContainer.responseData,
                          mockContainer.httpResponse,
                          mockContainer.responseError)
        mockContainer.onCompletedTask?()

        let dummyRequest = URLRequest(url: URL(string: "about:blank")!)
        // URLSessionDataTask object must be created by an URLSession object
        return originalSession.dataTask(with: dummyRequest)
    }
}
