import Foundation

// MARK: - RDeviceIdentifierKeychain

struct RDeviceIdentifierKeychain {
    let service: String
    let accessGroup: String

    init(service: String, accessGroup: String) {
        self.service = service
        self.accessGroup = accessGroup
    }

    /// Queries keychain for Data associated with service and app access group
    func search(for accessGroup: String) throws -> Data? {
        // Try to find the device identifier in the keychain.
        // Here we always have a bundle seed id.
        var searchQuery = query
        searchQuery[String(kSecMatchLimit)] = kSecMatchLimitOne
        searchQuery[String(kSecReturnData)] = true
        searchQuery[String(kSecAttrAccessGroup)] = accessGroup

        var result: CFTypeRef?
        let status = SecItemCopyMatching(searchQuery as CFDictionary, &result)
        try checkMissingAccessControl(status, for: accessGroup)

        if status == errSecSuccess, let result = result as? Data {
            return result
        }
        if status != errSecItemNotFound {
            throw RDeviceIdentifierError.keychainLocked
        }

        return nil
    }

    /// Saves to keychain Data on service and app access group
    func save(data: Data, for accessGroup: String) throws {
        var saveQuery = query
        saveQuery[String(kSecAttrAccessible)] = kSecAttrAccessibleWhenUnlocked
        saveQuery[String(kSecValueData)] = data
        saveQuery[String(kSecAttrAccessGroup)] = accessGroup

        let status = SecItemAdd(saveQuery as CFDictionary, nil)
        try checkMissingAccessControl(status, for: accessGroup)
        guard status == errSecSuccess else {
            throw RDeviceIdentifierError.keychainQueryFailed(status: status)
        }
    }

    /// Clears all Keychain values associated with service and app access group
    func clear() {
        SecItemDelete(query as CFDictionary)
    }

    // MARK: - Helpers

    private var query: [String: Any] {
        [String(kSecAttrService): service,
         String(kSecAttrAccount): service,
         String(kSecClass): kSecClassGenericPassword]
    }

    private func checkMissingAccessControl(_ status: OSStatus, for accessGroup: String) throws {
        if status == errSecNoAccessForItem {
            throw RDeviceIdentifierError.accessControl
        }
        if status == errSecMissingEntitlement {
            throw RDeviceIdentifierError.appGroupEntitlements(accessGroup: accessGroup)
        }
    }
}
