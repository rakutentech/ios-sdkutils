import Foundation
#if canImport(RSDKUtilsMain)
import RSDKUtilsMain
#endif

/// Collection of methods used to create a container which handles all dependencies in standard SDK usage
internal enum MainContainerFactory {

    private typealias ContainerElement = TypedDependencyManager.ContainerElement

    static func create(dependencyManager manager: TypedDependencyManager, appGroupId: String?) -> TypedDependencyManager.Container {

        let elements = [
            ContainerElement(type: NetworkManager.self, factory: {
                NetworkManager()
            }),
            ContainerElement(type: REventLoggerSendable.self, factory: {
                REventLoggerSender(networkManager: manager.resolve(type: NetworkManager.self )!)
            }),
            ContainerElement(type: REventDataCacheable.self, factory: {
                var userDefaults = UserDefaults.standard
                if let appGroupId,
                    let sharedUserdefaults = UserDefaults(suiteName: appGroupId) {
                    userDefaults = sharedUserdefaults
                }
                return REventsStorage(userDefaults: userDefaults)
            }),
            ContainerElement(type: REventExpirationCacheable.self, factory: { EventLoggerCache(ttlStorage: UserDefaults.standard)
            }),
            ContainerElement(type: AppLifeCycleListener.self, factory: {
                AppLifeCycleManager()
            }),
            ContainerElement(type: REventLoggerEnvironment.self, factory: {
                REventLoggerEnvironment()
            })
        ]
        return TypedDependencyManager.Container(elements)
    }
}
