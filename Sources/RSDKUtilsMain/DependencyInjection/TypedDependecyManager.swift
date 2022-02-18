import Foundation

/// This class is a solution for Dependency Injection
public class TypedDependencyManager {

    public typealias Container = [TypedDependencyManager.ContainerElement]
    public typealias Resolver = [(type: Any.Type, sharedInstance: Any)]

    public struct ContainerElement {
        fileprivate let type: Any.Type
        fileprivate let create: () -> Any?
        fileprivate let transient: Bool

        public init<T>(type: T.Type, factory: @escaping () -> T?, transient: Bool = false) {
            self.type = type
            self.create = factory
            self.transient = transient
        }
    }

    @AtomicGetSet private var resolver = Resolver()
    private var container = Container()

    public init() {
        // exposing public init
    }

    /// Adds new container to be used when resolving for the type enclosed in this container
    /// - Parameter container: A container to add
    public func appendContainer(_ container: Container) {
        self.container.append(contentsOf: container)
    }

    /// Function to get an instance of registered type
    /// - Parameter type: Type of the instance
    /// - Returns: An existing instance, or new instance in case of transient type, of given type
    public func resolve<T>(type: T.Type) -> T? {
        guard let existingInstance = resolver.last(where: { (registeredType, _) -> Bool in
            return registeredType == type
        })?.sharedInstance as? T else {
            guard let registeredElement = container.last(
                where: { element -> Bool in
                    return element.type == T.self
                })
            else { return nil }

            guard let instance = registeredElement.create() as? T?,
                let unwrappedInstance = instance else {
                return nil
            }

            if !registeredElement.transient {
                resolver.append((T.self, unwrappedInstance))
            }
            return unwrappedInstance
        }

        return existingInstance
    }
}
