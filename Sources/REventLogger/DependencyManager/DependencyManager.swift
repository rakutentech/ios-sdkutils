import Foundation
#if canImport(RSDKUtils)
import RSDKUtils // Cocoapods version
#else
import RSDKUtilsMain
#endif

/// Collection of methods used to create a container which handles all dependencies in standard SDK usage
internal enum MainContainerFactory {

    private typealias ContainerElement = TypedDependencyManager.ContainerElement

    static func create(dependencyManager manager: TypedDependencyManager) -> TypedDependencyManager.Container {

        let elements = [
            ContainerElement(type: NetworkManager.self, factory: {
                NetworkManager()
            }),
            ContainerElement(type: REventLoggerSendable.self, factory: {
                REventLoggerSender(networkManager: manager.resolve(type: NetworkManager.self )!)
            }),
            ContainerElement(type: EventDataCacheable.self, factory: {
                let userDefaults = UserDefaults(suiteName: "group" + REventLoggerEnvironment().appId)
                REventsStorage(userDefaults: userDefaults)
            })
        ]
        return TypedDependencyManager.Container(elements)
    }
}
