import Foundation

/// Descripe the type of the event
public enum EventType: Int, Codable {
    case critical, warning
}

struct EventLoggerConfiguration {
    let apiKey: String
    let apiUrl: String
}

/// Event Logger that sends the custom events to the Event Logger Service
public final class REventLogger {
    /// Singleton shared instance of REventLogger
    public static let shared = REventLogger()
    static var configration: EventLoggerConfiguration?

    private init() { }

    /// Function to configure the Event Logger
    /// - Parameters:
    ///   - apiKey: your API Key
    ///   - apiUrl: a API Endpoint
    public static func configure(apiKey: String, apiUrl: String) {
        guard configration != nil else {
            return
        }
        configration = EventLoggerConfiguration(apiKey: apiKey, apiUrl: apiUrl)
    }
    
    /// Logs the event which will be pushed to the backend either on demand or at a later time, based on the criticality of the event.
    /// - Parameters:
    ///   - type: Event type,  will accept EventType enum cases
    ///   - sourceName: Source name of the event e.g App name or SDK name
    ///   - sourceVersion: Version of the source e.g v1.0.0
    ///   - errorCode: Error code of the event, like custom error code or HTTP response error code
    ///   - errorMessage: Description of the error message.
    ///   - info: Any custom information. It's optional.
    public static func logEvent(_ type: EventType,
                                sourceName: String,
                                sourceVersion: String,
                                errorCode: String,
                                errorMessage: String,
                                info: [String: String]? = nil) {
        // Send the event to server
        // Save it in the local DB
    }
}
