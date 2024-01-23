import Foundation

#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
@testable import REventLogger
#endif

final class REventSenderMock: REventLoggerSendable {
    var response: Result<Data, Error> = .failure(REventError.internalServicesNotFound)
    func sendEvents(events: [REvent], onCompletion: @escaping (Result<Data, Error>) -> Void) {
        onCompletion(response)
    }
    var didConfigure = false
    func updateApiConfiguration(_ apiConfiguration: EventLoggerConfiguration?) {
        if let apiConfiguration = apiConfiguration {
            didConfigure = true
        } else {
            didConfigure = false
        }
    }
}

final class REventStorageMock: REventDataCacheable {
    var eventStorageDict: [String: REvent] = [:]

    func getAllEvents() -> [String: REvent] {
        return eventStorageDict
    }

    func retrieveEvent(_ id: String) -> REvent? {
        eventStorageDict[id]
    }

    func getEventCount() -> Int {
        eventStorageDict.count
    }

    func insertOrUpdateEvent(_ id: String, event: REvent) {
        eventStorageDict[id] = event
    }

    func deleteEvents(_ ids: [String]) {
        for key in ids {
            eventStorageDict.removeValue(forKey: key)
        }
    }

    func deleteOldEvents(maxCapacity: Int) {
        if getEventCount() <= maxCapacity {
            return
        }

        let sortedKeys = eventStorageDict.keys.sorted { eventStorageDict[$0]!.firstOccurrenceOn < eventStorageDict[$1]!.firstOccurrenceOn }
        deleteEvents(Array(sortedKeys.prefix(getEventCount() - maxCapacity)))
    }
}

final class REventsLoggerCacheMock: REventExpirationCacheable {
    let ttlStorage = UserDefaults.standard

    func getTtlReferenceTime() -> Int64 {
        if let ttlRefTime = ttlStorage.object(forKey: REventConstants.ttlKey) as? Int64 {
            return ttlRefTime
        } else { return -1 }
    }

    func setTtlReferenceTime(_ pushedTimeMs: Int64) {
        ttlStorage.set(pushedTimeMs, forKey: REventConstants.ttlKey)
    }
}

final class AppLifeCycleManagerMock: AppLifeCycleListener {
    var appBecameActiveObserver: (() -> Void)?

    func postDidBecomeActiveNotification() {
        appBecameActiveObserver?()
    }
}

enum REventLoggerMockData {
    static let apiKey = "e2io-34nj-70bh-oki8"
    static let apiUrl = "https://mock.eventlogger.end.point"
    static let REventModel = REvent(.critical,
                                    sdkName: "IAM",
                                    sdkVersion: "8.0,0",
                                    errorCode: "500",
                                    errorMessage: "Network Error")
    static let REventModel1 = REvent(.warning,
                                    sdkName: "IAM",
                                    sdkVersion: "8.0,0",
                                    errorCode: "400",
                                    errorMessage: "request sent to the server is invalid")
    static let REventModel2 = REvent(.warning,
                                    sdkName: "PNP",
                                    sdkVersion: "8.0,0",
                                    errorCode: "400",
                                    errorMessage: "request sent to the server is invalid")
    static let REventModel3 = REvent(.critical,
                                    sdkName: "Pitari",
                                    sdkVersion: "8.0,0",
                                    errorCode: "400",
                                    errorMessage: "request sent to the server is invalid")

    static let mockRefTime: Int64 = 10000000000
    static let mockRefTime2: Int64 = 1805542062408
}

enum REventError: Error {
    case internalServicesNotFound
}

extension REventError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .internalServicesNotFound:
            return "Unable to find any internal services for given API Key"
        }
    }
}
