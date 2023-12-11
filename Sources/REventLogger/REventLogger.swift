import Foundation

/// Describe the type of the event
public enum EventType: String, Codable {
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
    var configuration: EventLoggerConfiguration?

    private init() { }

    /// Function to configure the Event Logger
    /// - Parameters:
    ///   - apiKey: your API Key
    ///   - apiUrl: a API Endpoint
    public func configure(apiKey: String, apiUrl: String) {
        guard configuration != nil else {
            return
        }
        configuration = EventLoggerConfiguration(apiKey: apiKey, apiUrl: apiUrl)
    }

    /// Logs the critical event
    /// This event will be considered as high priority and will be sent immediately
    /// - Parameters:
    ///   - sourceName: Source name of the event e.g App name or SDK name
    ///   - sourceVersion: Version of the source e.g v1.0.0
    ///   - errorCode: Error code of the event, like custom error code or HTTP response error code
    ///   - errorMessage: Description of the error message.
    ///   - info: Any custom information. It's optional.
    public func sendCriticalEvent(sourceName: String,
                                  sourceVersion: String,
                                  errorCode: String,
                                  errorMessage: String,
                                  info: [String: String]? = nil) {
        // Send the event to server
        // Save it in the local DB, as warning
    }

    /// Logs the warning event
    /// This event will be considered as low priority and will be sent with batch update.
    /// - Parameters:
    ///   - sourceName: Source name of the event e.g App name or SDK name
    ///   - sourceVersion: Version of the source e.g v1.0.0
    ///   - errorCode: Error code of the event, like custom error code or HTTP response error code
    ///   - errorMessage: Description of the error message.
    ///   - info: Any custom information. It's optional.
    public func sendWarningEvent(sourceName: String,
                                 sourceVersion: String,
                                 errorCode: String,
                                 errorMessage: String,
                                 info: [String: String]? = nil) {
        // Save it in the local DB
    }
}
