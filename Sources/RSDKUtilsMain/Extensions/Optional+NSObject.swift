import Foundation

public extension Optional where Wrapped: NSObject {
    /// Check if an object is kind of a given class name.
    ///
    /// - Parameters:
    ///   - className: The class name.
    ///
    /// - Returns: A boolean.
    func isKind(of className: String) -> Bool {
        guard let anObject = self,
              anObject.isKind(of: className) else {
            return false
        }
        return true
    }

    /// Check if an object is member of a given class.
    ///
    /// - Parameters:
    ///   - aClass: The class.
    ///
    /// - Returns: A boolean.
    func isMember(of aClass: AnyClass) -> Bool {
        guard let anObject = self else {
            return false
        }
        return anObject.isMember(of: aClass)
    }

    /// Check if an object is an Apple class.
    ///
    /// - Parameters:
    ///   - aClass: The class.
    ///
    /// - Returns: A boolean.
    func isAppleClass() -> Bool {
        guard let anObject = self else {
            return false
        }
        return anObject.isAppleClass()
    }

    /// Check if an object is an Apple private class.
    ///
    /// - Returns: A boolean.
    func isApplePrivateClass() -> Bool {
        guard let anObject = self else {
            return false
        }
        return anObject.isApplePrivateClass()
    }

    /// Retrieve the hash value of an object.
    ///
    /// - Returns: The hash value or `0`.
    var safeHashValue: Int {
        guard let anObject = self else { return 0 }
        return anObject.hashValue
    }
}
