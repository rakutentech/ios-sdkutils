import Foundation

enum Constant {
    static let eventLoggerKey = "user-default-key-of-events"    // event logger key needs to be updated
}

struct EventLoggerInteractor: EventLogging {
    func logEvent(_ event: EventModel) {
        print(event)
        if event.isCritical {
            // send REventLogger critical event
        }else{
            // send REventLogger warning event
        }
    }

    func getStoredEvents() -> [String] {
        guard let data = UserDefaults.sharedDefaults?.value(forKey: Constant.eventLoggerKey) as? Data,
              let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            return []
        }
        return json.values.compactMap({ convertToString($0) })
    }

    private func convertToString(_ value: Any) -> String? {
        guard let dictionary = value as? [String: Any],
              let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted),
              let jsonString = String(data: data, encoding: .utf8) else {
            return nil
        }
        return jsonString
    }
}

extension UserDefaults {
    static let sharedDefaults = UserDefaults(suiteName: "group." + Bundle.main.bundleIdentifier!)
}
