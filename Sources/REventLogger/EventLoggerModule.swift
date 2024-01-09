import Foundation

#if SWIFT_PACKAGE
import RSDKUtilsMain
#else
import RSDKUtils
#endif

final class EventLoggerModule {
    private let eventsStorage: EventDataCacheable
    private let eventsSender: REventLoggerSendable
    private let loggerQueue = DispatchQueue(label: "eventLogger", qos: .utility)

    init(eventsStorage: EventDataCacheable, eventsSender: REventLoggerSendable) {
        self.eventsStorage = eventsStorage
        self.eventsSender = eventsSender
    }

    func configure(apiConfiguration: EventLoggerConfiguration) {
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
            if let storedEvent = self?.eventsStorage.retriveEvent(event.eventId) {
                isNewEvent = false
                event = storedEvent
                event.updateOccurrenceCount()
            }
            self?.eventsStorage.insertOrUpdateEvent(event.eventId, event: event)
            self?.sendEventIfNeeded(eventType, event.eventId, event, isNewEvent)
        }
    }

    func sendEventIfNeeded(_ eventType: EventType, _ eventId: String, _ event: REvent, _ isNewEvent: Bool) {
        // If full, send all of the events
        if eventsStorage.getEventCount() >= REventConstants.maxEventCount {
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
            case .failure(let error):
                Logger.debug(error)
                if deleteOldEventsOnFailure {
                    self.eventsStorage.deleteOldEvents(maxCapacity: 100)
                }
            }
        }
     }

    private func isEventValid(_ sourceName: String, _ sourceVersion: String, _ errorCode: String, _ errorMessage: String) -> Bool {
        let isValidSourceInfo = !(sourceName.isEmpty) && !(sourceVersion.isEmpty)
        let isValidErrorInfo = !(errorCode.isEmpty) && !(errorMessage.isEmpty)
        return isValidSourceInfo && isValidErrorInfo
    }
}
