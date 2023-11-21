import Foundation

protocol DataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSessionDataTask: DataTaskProtocol {}

protocol URLSessionProtocol {
    func createDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> DataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func createDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> DataTaskProtocol {
        dataTask(with: request, completionHandler: completionHandler) as DataTaskProtocol
    }
}
