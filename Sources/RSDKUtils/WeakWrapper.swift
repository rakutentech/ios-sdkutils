/// Class that stores weak reference to the wrapped object.
/// It can be used used to avoid retain cycles in some cases.
public class WeakWrapper<T> {
    // T cannot be restricted to AnyObject in order to support protocols
    private weak var _value: AnyObject?
    var value: T? {
        return _value as? T
    }

    init(value: AnyObject) {
        self._value = value
    }
}
