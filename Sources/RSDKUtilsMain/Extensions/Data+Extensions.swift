import Foundation
import CommonCrypto

public extension Data {
    var hexString: String {
        map { String(format: "%02hhx", $0) }.joined()
    }

    var sha256Hex: String? {
        guard !isEmpty else {
            return nil
        }

        var dataOut = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        var bytes = [UInt8](repeating: 0, count: count)
        (self as NSData).getBytes(&bytes, length: count)
        CC_SHA256(bytes, CC_LONG(count), &dataOut)
        return Data(dataOut).hexString
    }
}
