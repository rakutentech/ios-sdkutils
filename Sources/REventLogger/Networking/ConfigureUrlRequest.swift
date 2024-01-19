import Foundation

protocol ConfigureUrlRequest {
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Encodable? { get }
    var path: String { get }
    func createURLRequest(with url: URL) -> URLRequest?
}

extension ConfigureUrlRequest {
    func createURLRequest(with url: URL) -> URLRequest? {
        guard let url = buildUrlFrom(baseUrl: url) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let body = body {
            do {
                let encoder = JSONEncoder()
                request.httpBody = try encoder.encode(body)
            } catch {
                Logger.debug("failed creating a request body.")
                return nil
            }
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { header in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        return request
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
    case noData
    case invalidHeader

    var errorDescription: String? {
        switch self {
        case .invalidHeader:
            return "Header is invalid"
        case .invalidURL:
            return "URL is invalid"
        case .noData:
            return "Response data is nil"
        case .invalidRequest:
            return "Unable to create URLRequest"
        }
    }
}
