import Foundation

public extension Optional where Wrapped == String {
    /// Retrieve the hash value of a string.
    ///
    /// - Returns: The hash value or `0`.
    var safeHashValue: Int {
        guard let str = self else { return 0 }
        return str.hashValue
    }

    var isEmpty: Bool {
        guard let str = self else { return true }
        return str.isEmpty
    }
}
