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

enum REventConstants {
    enum RequestHeaderKey {
        static let clientApiKey = "x-client-apikey"
    }
    static let maxEventCount = 100
    static let ttlExpiryInMillis = 3600 * 1000 * 12
    static let ttlKey = "ttl_reference_time"
    static let retryDelayMS = 15 * 1000
    static let maxRetryAttempt = 2
}

internal enum Logger {
    static func debug(_ value: Any) {
        #if DEBUG
        print("REventLogger: " + String(describing: value))
        #endif
    }

    static func debug(_ message: String) {
        #if DEBUG
        print("REventLogger: " + message)
        #endif
    }
}

extension Date {
    var timeInMilliseconds: Int64 {
        Int64(self.timeIntervalSince1970 * 1000)
    }
}

extension NSError {
    var isNetworkConnectivityError: Bool {
        self.code == URLError.notConnectedToInternet.rawValue ||
        self.code == URLError.networkConnectionLost.rawValue
    }
}
