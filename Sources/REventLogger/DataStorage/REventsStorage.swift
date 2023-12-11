import Foundation

#if SWIFT_PACKAGE
import class RSDKUtilsMain.AtomicGetSet
#else
import class RSDKUtils.AtomicGetSet
#endif

internal protocol EventDataCacheable {

    func getAllEvents() -> [REvent]
    func retriveEvent(_ id: String) -> REvent?
    func getEventCount() -> Int
    func insertOrUpdateEvent(_ id: String, event: REvent)
    func deleteEvents(_ ids: [String])
    func deleteOldEvents(maxCapacity: Int)
}

internal class EventDataCache: EventDataCacheable {
    
    private typealias CacheContainer = [String: REvent]
    private let userDefaults: UserDefaults
    @AtomicGetSet private var cachedContainer: CacheContainer
    private let persistedDataKey = "Event_logger_cache"

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults

        if let persistedData = userDefaults.object(forKey: persistedDataKey) as? Data {
            do {
                let decodedData = try JSONDecoder().decode(CacheContainer.self, from: persistedData)
                cachedContainer = decodedData
            } catch {
                cachedContainer = [:]
            }
        } else {
            cachedContainer = [:]
        }
    }

    func getAllEvents() -> [REvent] {
        Array(cachedContainer.values)
    }

    func retriveEvent(_ id: String) -> REvent? {
        cachedContainer[id]
    }

    func deleteEvents(_ ids: [String]) {
        for key in ids {
            cachedContainer.removeValue(forKey: key)
        }
        saveData()
    }

    func getEventCount() -> Int {
        cachedContainer.count
    }

    func insertOrUpdateEvent(_ id: String, event: REvent) {
        cachedContainer[id] = event
        saveData()
    }

    func deleteOldEvents(maxCapacity: Int) {
        if getEventCount() <= maxCapacity {
            return
        }

        let sortedKeys = cachedContainer.keys.sorted { cachedContainer[$0]!.firstOccurrenceOn < cachedContainer[$1]!.firstOccurrenceOn }
        deleteEvents(Array(sortedKeys.prefix(getEventCount() - maxCapacity)))
        saveData()
    }

    private func saveData() {
        do {
            let encodedData = try JSONEncoder().encode(cachedContainer)
            userDefaults.set(encodedData, forKey: persistedDataKey)
        } catch {
            assertionFailure()
        }
    }
}
