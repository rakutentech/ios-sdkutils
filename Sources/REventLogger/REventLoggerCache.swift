import Foundation

protocol REventLoggerCacheable {
    func getTtlReferenceTime() -> Int64
    func setTtlReferenceTime(_ pushedTimeMs: Int64)
    func getCurrentTimeInMilliseconds() -> Int64
}

class EventLoggerCache: REventLoggerCacheable {

    let ttlStorage = UserDefaults.standard

    func getTtlReferenceTime() -> Int64 {
        if let ttlRefTime = ttlStorage.object(forKey: REventConstants.ttlKey) as? Int64 {
            return ttlRefTime
        } else { return -1 }
    }

    func setTtlReferenceTime(_ pushedTimeMs: Int64) {
        ttlStorage.set(pushedTimeMs, forKey: REventConstants.ttlKey)
    }

    func getCurrentTimeInMilliseconds() -> Int64 {
        let currentDate = Date()
        let timeInMilliseconds = Int64(currentDate.timeIntervalSince1970 * 1000)
        return timeInMilliseconds
    }
}
