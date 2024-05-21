import Foundation

protocol REventExpirationCacheable {
    func getTtlReferenceTime() -> Int64
    func setTtlReferenceTime(_ pushedTimeMs: Int64)
}

class EventLoggerCache: REventExpirationCacheable {

    private let ttlStorage: UserDefaults
    init(ttlStorage: UserDefaults) {
        self.ttlStorage = ttlStorage
    }

    func getTtlReferenceTime() -> Int64 {
        if let ttlRefTime = ttlStorage.object(forKey: REventConstants.ttlKey) as? Int64 {
            return ttlRefTime
        } else { return -1 }
    }

    func setTtlReferenceTime(_ pushedTimeMs: Int64) {
        ttlStorage.set(pushedTimeMs, forKey: REventConstants.ttlKey)
    }
}
