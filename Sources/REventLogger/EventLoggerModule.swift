import Foundation

#if SWIFT_PACKAGE
import RSDKUtilsMain
#else
import RSDKUtils
#endif

final class REventLoggerModule {
    private let eventsStorage: REventDataCacheable
    private let eventsSender: REventLoggerSendable
    private let eventsCache: REventExpirationCacheable
    private var appLifeCycleListener: AppLifeCycleListener
    private let loggerQueue = DispatchQueue(label: "eventLogger", qos: .utility)

    init(eventsStorage: REventDataCacheable,
         eventsSender: REventLoggerSendable,
         eventsCache: REventExpirationCacheable,
         appLifeCycleListener: AppLifeCycleListener) {
        self.eventsStorage = eventsStorage
        self.eventsSender = eventsSender
        self.eventsCache = eventsCache
        self.appLifeCycleListener = appLifeCycleListener
        self.appLifeCycleListener.appBecameActiveObserver = { [weak self] in
            self?.checkEventsExpirationAndStorage()
        }
    }

    func configure(apiConfiguration: EventLoggerConfiguration?) {
        eventsSender.updateApiConfiguration(apiConfiguration)
    }

    func logEvent(_ eventType: EventType,
                  _ sourceName: String,
                  _ sourceVersion: String,
                  _ errorCode: String,
                  _ errorMessage: String,
                  _ info: [String: String]?) {

        if !isEventValid(sourceName, sourceVersion, errorCode, errorMessage) {
            Logger.debug("Event Logger event contains an empty parameter")
            return
        }
        var isNewEvent = true

        loggerQueue.async { [weak self] in
            var event = REvent(eventType,
                               sourceName: sourceName,
                               sourceVersion: sourceVersion,
                               errorCode: errorCode,
                               errorMessage: errorMessage,
                               info: info)
            if let storedEvent = self?.eventsStorage.retrieveEvent(event.eventId) {
                isNewEvent = false
                event = storedEvent
                event.updateOccurrenceCount()
            }
            self?.eventsStorage.insertOrUpdateEvent(event.eventId, event: event)
            self?.sendEventIfNeeded(eventType, event.eventId, event, isNewEvent)
        }
    }

    func sendEventIfNeeded(_ eventType: EventType, _ eventId: String, _ event: REvent, _ isNewEvent: Bool, maxEventCount: Int = REventConstants.maxEventCount) {
        // If full, send all of the events
        if eventsStorage.getEventCount() >= maxEventCount {
            sendAllEventsInStorage(deleteOldEventsOnFailure: isNewEvent)
            return
        }
        if isNewEvent && eventType == .critical {
            sendCriticalEvent(eventId, event)
        }
    }

    func sendCriticalEvent(_ eventId: String, _ event: REvent) {
        // Send the unique critical event immediately, and convert it to a warning type to prevent multiple alerts in server
        var criticalEvent = event
        eventsSender.sendEvents(events: [criticalEvent]) { result in
            switch result {
            case .success:
                criticalEvent.updateEventType(type: .warning)
                self.eventsStorage.insertOrUpdateEvent(eventId, event: criticalEvent)
            case .failure(let error):
                Logger.debug(error)
            }
        }
    }

    func sendAllEventsInStorage(deleteOldEventsOnFailure: Bool = false) {
        let eventsStorage = self.eventsStorage.getAllEvents()
        let storedEvents = (ids: Array(eventsStorage.keys), events: Array(eventsStorage.values))
        eventsSender.sendEvents(events: storedEvents.events) { result in
            switch result {
            case .success:
                self.eventsStorage.deleteEvents(storedEvents.ids)
                self.eventsCache.setTtlReferenceTime(Date().timeInMilliseconds)
            case .failure(let error):
                Logger.debug(error)
                if deleteOldEventsOnFailure {
                    self.eventsStorage.deleteOldEvents(maxCapacity: REventConstants.maxEventCount)
                }
            }
        }
    }

    func isEventValid(_ sourceName: String, _ sourceVersion: String, _ errorCode: String, _ errorMessage: String) -> Bool {
        let isValidSourceInfo = !(sourceName.isEmpty) && !(sourceVersion.isEmpty)
        let isValidErrorInfo = !(errorCode.isEmpty) && !(errorMessage.isEmpty)
        return isValidSourceInfo && isValidErrorInfo
    }

    func isTtlExpired() -> Bool {
        let currentTime = Date().timeInMilliseconds
        let referenceTime = eventsCache.getTtlReferenceTime()

        if referenceTime == -1 {
            eventsCache.setTtlReferenceTime(currentTime)
            return false
        }
        return currentTime - referenceTime >= REventConstants.ttlExpiryInMillis
    }

    private func checkEventsExpirationAndStorage() {
        loggerQueue.async { [weak self] in
            guard let self else { return }
            if self.isTtlExpired() == true || self.eventsStorage.getEventCount() >= REventConstants.maxEventCount {
                self.sendAllEventsInStorage()
                return
            }
        }
    }
}
