import Foundation

struct APIError: Decodable, Equatable {
    let status: Int
    let error: String
}

extension NSError {
    class func error(code: Int, message: String) -> NSError {
        return NSError(domain: "EventLogger", code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}

struct ErrorCode {
    static let unknown = 1001
}

struct ErrorMessage {
    static let unknown = "Unspecified server error occurred."
}
