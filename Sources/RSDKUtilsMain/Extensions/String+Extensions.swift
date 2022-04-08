import Foundation

// MARK: - Encoding

public extension CharacterSet {
    /// See https://www.ietf.org/rfc/rfc3986.txt section 2.2 and 3.4
    static let RFC3986ReservedCharacters = ":#[]@!$&'()*+,;="
    static let RFC3986UnreservedCharacters: CharacterSet = {
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: RFC3986ReservedCharacters)
        return allowed
    }()
}

public extension String {
    /// Encode a String following the RFC3986 specifications.
    ///
    /// - Returns: the RFC3986 encoded string.
    func addEncodingForRFC3986UnreservedCharacters() -> String? {
        addingPercentEncoding(withAllowedCharacters: CharacterSet.RFC3986UnreservedCharacters)
    }
}

// MARK: - Subscript

public extension String {
    subscript (range: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start ..< end])
    }
}

// MARK: - Base64

public extension String {
    /// Encode a String to Base64.
    ///
    /// - Returns: the  Base64 encoded string.
    var toBase64: String { Data(utf8).base64EncodedString() }

    /// Encode a UTF-8 String to Base64 SHA256.
    ///
    /// - Returns: Base64 encoded string.
    var sha256Hex: String? { data(using: .utf8)?.sha256Hex }
}
