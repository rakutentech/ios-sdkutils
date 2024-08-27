import Foundation

// MARK: - Constants

public extension NSNotification.Name {
    static let rAnalyticsCustomEvent = Notification.Name(rawValue: "com.rakuten.esd.sdk.events.custom")
}

// MARK: - Public API

/// Utility class to broadcast events to Analytics SDK.
@objc public final class AnalyticsBroadcaster: NSObject {
    /// This method will broadcast an event to the Analytics SDK for them to send to RAT.
    /// - Parameter name: Name of the event to be sent to Analytics SDK.
    /// - Parameter dataObject: Optional dictionary to pass in any other data to RAT.
    /// - Parameter customAccountNumber: When set, the event will be sent to this RAT account number instead of the one set in the app (optional).
    ///                                  The value should be a positive integer.
    @objc public static func sendEventName(_ name: String, dataObject: [String: Any]? = nil, customAccountNumber: NSNumber? = nil) {
        var parameters: [String: Any] = ["eventName": name]
        if let dataObject = dataObject {
            parameters["eventData"] = dataObject
        }
        if let customAccountNumber = customAccountNumber, customAccountNumber.intValue > 0 {
            parameters["customAccNumber"] = customAccountNumber
        }

        NotificationCenter.default.post(name: .rAnalyticsCustomEvent, object: parameters)
    }
}
