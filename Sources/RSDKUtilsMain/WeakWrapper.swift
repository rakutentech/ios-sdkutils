/// Class that stores weak reference to the wrapped object.
/// It can be used used to avoid retain cycles in some cases.
public class WeakWrapper<T> {
    // T cannot be restricted to AnyObject in order to support protocols
    private weak var internalValue: AnyObject?
    public var value: T? {
        internalValue as? T
    }

    public init(value: AnyObject) {
        internalValue = value
    }
}
