import Foundation

protocol ConfigureUrlRequest {
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var path: String { get }
    func createURLRequest(with url: URL, body: [REvent]?) -> URLRequest?
}

extension ConfigureUrlRequest {
    func createURLRequest(with url: URL, body: [REvent]?) -> URLRequest? {
        guard let url = buildUrlFrom(baseUrl: url) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let body = body {
            do {
                let encoder = JSONEncoder()
                encoder.keyEncodingStrategy = .convertToSnakeCase
                request.httpBody = try encoder.encode(body)
            } catch {
                return nil
            }
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        header?.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        return request
    }

    var header: [String: String]? {
        nil
    }

    func buildUrlFrom(baseUrl: URL) -> URL? {
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        var absolutePath = path
        if let rootPath = urlComponents?.path {
            absolutePath = rootPath + absolutePath
        }
        urlComponents?.path = absolutePath
        return urlComponents?.url
    }
}

enum HTTPMethod: String {
    case post
    case get
}

enum RequestError: Error, LocalizedError {
    case invalidURL
    case invalidRequest
    case invalidHeader
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL is invalid"
        case .noData:
            return "Response data is nil"
        case .invalidHeader:
            return "Unable to build request header"
        case .invalidRequest:
            return "Unable to create URLRequest"
        }
    }
}
