import Foundation

#if canImport(RSDKUtilsMain)
import RSDKUtilsMain
#endif

struct EventLoggerConfiguration {
    let apiKey: String
    let apiUrl: String
    let appGroupId: String?
}

/// Event Logger that sends the custom events to the Event Logger Service
public final class REventLogger {
    /// Singleton shared instance of REventLogger
    public static let shared = REventLogger()
    private(set) var eventLogger: REventLoggerModule?
    private(set) var dependencyManager: TypedDependencyManager?
    var configuration: EventLoggerConfiguration?
    private var isConfigured = false

    private init() {
        // This initializer is private to prevent instantiation.
    }

    /// Function to configure the Event Logger
    /// - Parameters:
    ///   - apiKey: your API Key
    ///   - apiUrl: a API Endpoint
    public func configure(apiKey: String?,
                          apiUrl: String?,
                          appGroupId: String?,
                          onCompletion: ((Bool, String) -> Void)? = nil) {
        guard configuration == nil else {
            Logger.debug("EventLogger is already configured")
            onCompletion?(true, "EventLogger is already configured")
            return
        }

        guard let apiKey = apiKey, let apiUrl = apiUrl else {
            onCompletion?(false, "EventLogger cannot be configured due to invalid api parameters")
            return
        }

        configuration = EventLoggerConfiguration(apiKey: apiKey, apiUrl: apiUrl, appGroupId: appGroupId)
        configureModules(dependencyManager: resolveDependency())
        eventLogger?.configure(apiConfiguration: configuration)
        isConfigured = true
        onCompletion?(true, "EventLogger is configured")

        if eventLogger?.isTtlExpired() == true {
            eventLogger?.sendAllEventsInStorage()
        }
    }

    /// Logs the critical event
    /// This event will be considered as high priority and will be sent immediately
    /// - Parameters:
    ///   - sourceName: Source name of the event e.g App name or SDK name
    ///   - sourceVersion: Version of the source e.g v1.0.0
    ///   - errorCode: Error code of the event, like custom error code or HTTP response error code
    ///   - errorMessage: Description of the error message.
    ///   - info: Any custom information. It's optional.
    public func sendCriticalEvent(sourceName: String,
                                  sourceVersion: String,
                                  errorCode: String,
                                  errorMessage: String,
                                  info: [String: String]? = nil,
                                  completion: (() -> Void?)? = nil) {
        if isConfigured {
            eventLogger?.logEvent(EventType.critical, sourceName, sourceVersion, errorCode, errorMessage, info, completion)
        }
    }

    /// Logs the warning event
    /// This event will be considered as low priority and will be sent with batch update.
    /// - Parameters:
    ///   - sourceName: Source name of the event e.g App name or SDK name
    ///   - sourceVersion: Version of the source e.g v1.0.0
    ///   - errorCode: Error code of the event, like custom error code or HTTP response error code
    ///   - errorMessage: Description of the error message.
    ///   - info: Any custom information. It's optional.
    public func sendWarningEvent(sourceName: String,
                                 sourceVersion: String,
                                 errorCode: String,
                                 errorMessage: String,
                                 info: [String: String]? = nil,
                                 completion: (() -> Void?)? = nil) {
        if isConfigured {
            eventLogger?.logEvent(EventType.warning, sourceName, sourceVersion, errorCode, errorMessage, info, completion)
        }
    }

    private func resolveDependency() -> TypedDependencyManager {
        let manager = TypedDependencyManager()
        let mainContainer = MainContainerFactory.create(dependencyManager: manager, appGroupId: configuration?.appGroupId)
        manager.appendContainer(mainContainer)
        return manager
    }

    private func configureModules(dependencyManager: TypedDependencyManager) {
        self.dependencyManager = dependencyManager
        guard let dataStorage = dependencyManager.resolve(type: REventDataCacheable.self),
              let eventsSender = dependencyManager.resolve(type: REventLoggerSendable.self),
              let eventsCache = dependencyManager.resolve(type: REventExpirationCacheable.self),
              let appLifeCycleManager = dependencyManager.resolve(type: AppLifeCycleListener.self),
              let appBundle = dependencyManager.resolve(type: REventLoggerEnvironment.self)
        else {
            Logger.debug("❌ Unable to resolve dependencies of EventLogger")
            return
        }
        eventLogger = REventLoggerModule(eventsStorage: dataStorage,
                                         eventsSender: eventsSender,
                                         eventsCache: eventsCache,
                                         appLifeCycleListener: appLifeCycleManager,
                                         appBundle: appBundle)
    }
}
