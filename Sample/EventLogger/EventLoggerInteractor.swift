import Foundation
import RSDKUtils

enum Constant {
    static let eventLoggerKey = "event_logger_cached_events"
}

struct EventLoggerInteractor: EventLogging {
    func logEvent(_ event: EventModel, completionHandler: @escaping ((Bool) -> Void)) {
        let info = convertToJson(event.info)
        for _ in 1...event.count {
            DispatchQueue.main.async {
                if event.isCritical {
                    REventLogger.shared.sendCriticalEvent(sourceName: event.sdkName,
                                                          sourceVersion: event.sdkVersion,
                                                          errorCode: event.errorCode,
                                                          errorMessage: event.errorMessage,
                                                          info: info)
                }else{
                    REventLogger.shared.sendWarningEvent(sourceName: event.sdkName,
                                                         sourceVersion: event.sdkVersion,
                                                         errorCode: event.errorCode,
                                                         errorMessage: event.errorMessage,
                                                         info: info)
                }
            }
        }
        completionHandler(true)

        func convertToJson(_ jsonString: String) -> [String: String]? {
            guard let data = jsonString.data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else {
                return nil
            }
            return json
        }
    }

    func getStoredEvents() -> [String] {
        guard let data = UserDefaults.sharedDefaults?.value(forKey: Constant.eventLoggerKey) as? Data,
              let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            return []
        }
        let sortedValues = json.values.compactMap({$0 as? [String: Any]})
            .sorted(by: { $0["firstOccurrenceOn"] as! Double > $1["firstOccurrenceOn"] as! Double })
        return sortedValues.compactMap({ convertToString($0) })
    }

    func getConfiguration() -> (apiKey: String, apiEndpoint: String) {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "EventLoggerAPIKey") as? String ?? ""
        let apiEndpoint = Bundle.main.object(forInfoDictionaryKey: "EventLoggerAPIEndpoint") as? String ?? ""
        return (apiKey, apiEndpoint)
    }

    private func convertToString(_ value: [String: Any]) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: value, options: [.sortedKeys, .prettyPrinted]),
              let jsonString = String(data: data, encoding: .utf8) else {
            return nil
        }
        return jsonString
    }
}

extension UserDefaults {
    static let sharedDefaults = UserDefaults(suiteName: "group." + Bundle.main.bundleIdentifier!)
}
