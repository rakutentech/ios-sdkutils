import Foundation

public extension Dictionary {
    /// Add entries to a dictionary.
    static func += (lhs: inout Dictionary, rhs: Dictionary) {
        for (key, value) in rhs {
            lhs[key] = value
        }
    }
}
