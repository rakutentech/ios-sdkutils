import Foundation
import UIKit

public extension NSObject {
    /// Check if an object is kind of a given class name.
    ///
    /// - Parameters:
    ///   - className: The class name.
    ///
    /// - Returns: A boolean.
    func isKind(of className: String) -> Bool {
        guard let aClass = NSClassFromString(className),
              isKind(of: aClass.self) else {
            return false
        }
        return true
    }

    /// Check if an object is an Apple class.
    ///
    /// - Returns: A boolean.
    func isAppleClass() -> Bool {
        NSObject.isAppleClass(type(of: self).self)
    }

    /// Check if an object is an Apple private class.
    ///
    /// - Returns: A boolean.
    func isApplePrivateClass() -> Bool {
        NSObject.isApplePrivateClass(type(of: self).self)
    }
}

public extension NSObject {
    
    static func isAppleClass(_ cls: AnyClass?) -> Bool {
        guard let appleClass = cls,
              let bundleIdentifier = Bundle(for: appleClass.self).bundleIdentifier else {
            return false
        }
        return bundleIdentifier.hasPrefix("com.apple.")
    }

    static func isApplePrivateClass(_ cls: AnyClass?) -> Bool {
        guard let cls = cls else {
            return false
        }
        return NSStringFromClass(cls).hasPrefix("_") && NSObject.isAppleClass(cls)
    }

    static func isNullableObjectEqual(_ objA: NSObject?, to objB: NSObject?) -> Bool {
        guard let objectA = objA, let objectB = objB else {
            return objA == nil && objB == nil
        }
        return objectA.isEqual(objectB)
    }
}
