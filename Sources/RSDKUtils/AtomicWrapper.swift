import Foundation

/// This wrapper ensures synchronized access to the value only for getter and setter.
/// Mutating functions, subscript, incrementation etc. are not synchronized by default -
/// use `mutate` function to ensure operation atomicity.
@propertyWrapper
public class AtomicGetSet<Value> {
    private let queue = PropertyQueueGenerator.spawnQueue(domain: "RSDKUtils.AtomicProperty")
    private var value: Value

    public init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    public var wrappedValue: Value {
        get {
            return queue.sync { value }
        }
        set {
            queue.sync(flags: .barrier) { value = newValue }
        }
    }

    public func mutate(_ mutation: (inout Value) -> Void) {
        queue.sync(flags: .barrier) {
            mutation(&value)
        }
    }
}

private struct PropertyQueueGenerator {
    private static var lastQueueNumber = UInt(0)

    static func spawnQueue(domain: String) -> DispatchQueue {
        lastQueueNumber += 1
        return DispatchQueue(label: domain + "\(lastQueueNumber))", attributes: .concurrent)
    }
}
