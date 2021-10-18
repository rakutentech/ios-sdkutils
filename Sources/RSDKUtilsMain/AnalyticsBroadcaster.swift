import Foundation

// MARK: - Constants

extension NSNotification.Name {
    static let sdkCustomEvent = Notification.Name(rawValue: "com.rakuten.esd.sdk.events.custom")
}

// MARK: - Public API

/// Utility class to broadcast events to Analytics SDK.
@objc public final class AnalyticsBroadcaster: NSObject {
    /// This method will broadcast an event to the Analytics SDK for them to send to RAT.
    /// - Parameter name: Name of the event to be sent to Analytics SDK.
    /// - Parameter dataObject: Optional dictionary to pass in any other data to RAT.
    @objc public class func sendEventName(_ name: String, dataObject: [String: Any]? = nil) {
        var parameters: [String: Any] = ["eventName": name]
        if let dataObject = dataObject {
            parameters["eventData"] = dataObject
        }

        NotificationCenter.default.post(name: .sdkCustomEvent, object: parameters)
    }
}
