import Foundation

struct APIError: Decodable, Equatable {
    let status: Int?
    let error: String?
}

extension NSError {
    class func error(code: Int, message: String) -> NSError {
        return NSError(domain: "EventLogger", code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}

enum ErrorCode {
    static let unknown = 1001
}

enum ErrorMessage {
    static let unknown = "Unspecified server error occurred."
}

enum REventConsants {
    enum RequestHeaderKey {
        static let clientApiKey = "x-client-apikey"
    }
}
