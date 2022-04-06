import CoreLocation.CLLocation

public extension Optional where Wrapped: CLLocation {
    /// Retrieve the hash value of a CLLocation instance.
    ///
    /// - Returns: The hash value or `0`.
    var safeHashValue: Int {
        guard let anObject = self else { return 0 }
        return anObject.description.hashValue
    }
}
