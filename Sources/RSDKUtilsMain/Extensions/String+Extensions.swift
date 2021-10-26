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

// MARK: - Base64

public extension String {
    /// Encode a String to Base64.
    ///
    /// - Returns: the  Base64 encoded string.
    var toBase64: String { Data(utf8).base64EncodedString() }
}
