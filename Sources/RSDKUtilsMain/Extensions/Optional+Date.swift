import Foundation

public extension Optional where Wrapped == Date {
    /// Retrieve the hash value of a string.
    ///
    /// - Returns: The hash value or `0`.
    var safeHashValue: Int {
        guard let date = self else { return 0 }
        return date.hashValue
    }
}
