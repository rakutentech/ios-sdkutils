import Foundation

@objc public class KeyStore: NSObject {
    let service: String
    var account: String

    typealias KeysDictionary = [String: String]

    public init(service: String = Bundle.main.bundleIdentifier!) {
        self.service = service
        self.account = "\(service).rakuten.tech.keys"
    }

    public func key(for keyId: String) -> String? {
        return keys()?[keyId]
    }

    public func addKey(key: String, for keyId: String) {
        var keysDic = keys()
        guard keysDic?[keyId] == nil else {
            return // key exists
        }

        if keysDic != nil {
            keysDic?[keyId] = key
        } else {
            keysDic = [keyId: key]
        }

        if let keys = keysDic {
            write(keys: keys)
        }
    }

    public func removeKey(for keyId: String) {
        var keysDic = keys()

        keysDic?[keyId] = nil

        if let keys = keysDic {
            write(keys: keys)
        }
    }

    public func empty() {
        write(keys: [:])
    }

    private func write(keys: KeysDictionary) {
        guard let data = try? JSONSerialization.data(withJSONObject: keys, options: []) else {
            return
        }

        let queryFind: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        let update: [String: Any] = [
            kSecValueData as String: data
        ]

        var status = SecItemUpdate(queryFind as CFDictionary, update as CFDictionary)

        if status == errSecItemNotFound {
            let queryAdd: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: account,
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            ]
            status = SecItemAdd(queryAdd as CFDictionary, nil)
        }

        if status != errSecSuccess {
            var error: String?
            if #available(iOS 11.3, *) {
                error = SecCopyErrorMessageString(status, nil) as String?
            } else {
                error = "OSStatus \(status)"
            }
            print("KeyStore write error \(String(describing: error))")
        }
    }

    private func keys() -> KeysDictionary? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let objectData = result as? Data else {
            return nil
        }

        guard let keys = try? JSONSerialization.jsonObject(with: objectData, options: []) as? KeysDictionary else {
            return nil
        }

        return keys
    }
}
