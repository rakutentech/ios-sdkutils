import Foundation

/// This class is a solution for Dependency Injection
public class TypedDependencyManager {

    public typealias Container = [TypedDependencyManager.ContainerElement]
    public typealias Resolver = [(type: Any.Type, sharedInstance: Any)]

    public struct ContainerElement {
        let type: Any.Type
        let create: () -> Any?
        let transient: Bool

        init<T>(type: T.Type, factory: @escaping () -> T?, transient: Bool = false) {
            self.type = type
            self.create = factory
            self.transient = transient
        }
    }

    @AtomicGetSet private var resolver = Resolver()
    private var container = Container()

    /// Adds new container to be used when resolving for the type enclosed in this container
    /// - Parameter container: A container to add
    public func appendContainer(_ container: Container) {
        self.container.append(contentsOf: container)
    }

    /// Function to get an instance of registered type
    /// - Parameter type: Type of the instance
    /// - Returns: An existing instance, or new instance in case of transient type, of given type
    public func resolve<T>(type: T.Type) -> T? {
        guard let existingInstance = resolver.last(where: { (type, _) -> Bool in
            return type == T.self
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

            if registeredElement.transient == false {
                resolver.append((T.self, unwrappedInstance))
            }
            return unwrappedInstance
        }

        return existingInstance
    }
}
