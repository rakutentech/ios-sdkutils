import Foundation

/// Protocol to mark object that have resources that can be thread locked
public protocol Lockable {
    var resourcesToLock: [LockableResource] { get }
}

public protocol LockableResource {

    /// Lock resource for caller's thread use
    func lock()

    /// Unlock resource. Access from other threads will be resumed
    func unlock()
}

/// Object-wrapper that conforms to LockableResource protocol.
/// Used to control getter and setter of given resource.
/// When lock() has been called on some thread, only that thread will be able to access the resource.
/// Other threads will synchronously wait for unlock() call to continue.
public class LockableObject<T>: LockableResource {
    private var resource: T
    private let dispatchGroup = DispatchGroup()
    @AtomicGetSet private var lockingThread: Thread?
    @AtomicGetSet private var lockCount: UInt = 0
    private var shouldWait: Bool {
        assert(!(isLocked && lockingThread == nil), "Thread was deallocated before calling unlock()")
        return isLocked && lockingThread != nil && lockingThread != Thread.current
    }

    public var isLocked: Bool { lockCount > 0 }

    public init(_ resource: T) {
        self.resource = resource
    }

    deinit {
        for _ in [0..<lockCount] {
            unlock()
        }
    }

    public func lock() {
        if shouldWait {
            dispatchGroup.wait()
        }
        _lockCount.mutate { $0 += 1 }
        lockingThread = Thread.current
        dispatchGroup.enter()
    }

    public func unlock() {
        if lockCount > 0 {
            _lockCount.mutate { $0 -= 1 }
            dispatchGroup.leave()
        } else {
            lockingThread = nil
        }
    }

    public func get() -> T {
        if shouldWait {
            dispatchGroup.wait()
            return resource
        } else {
            return resource
        }
    }

    public func set(value: T) {
        if shouldWait {
            dispatchGroup.wait()
            resource = value
        } else {
            resource = value
        }
    }
}
