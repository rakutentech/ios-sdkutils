import Foundation
#if !canImport(RSDKUtils)
import RSDKUtilsMain // Required in SPM version
#endif

// MARK: - RDeviceIdentifierKeychain

struct RDeviceIdentifierKeychain {
    func getAccessGroups() throws -> (internalAccessGroup: String, defaultAccessGroup: String)? {
        // First, try to grab the application identifier prefix (=bundle seed it)
        // and build the access group from it.
        do {
            guard let result = try addIfNonExistent(),
                  let defaultAccessGroup = result[String(kSecAttrAccessGroup)] as? String,
                  let teamName = defaultAccessGroup.components(separatedBy: ".").first else {
                return nil
            }
            let accessGroup = "\(teamName).\(RDeviceIdentifierConstants.keychainAccessGroup)"
            return (accessGroup, defaultAccessGroup)
        } catch let err {
            throw err
        }
    }

    func search(for accessGroup: String) throws -> Data? {
        // Try to find the device identifier in the keychain.
        // Here we always have a bundle seed id.
        var searchQuery = query
        searchQuery[String(kSecMatchLimit)] = kSecMatchLimitOne
        searchQuery[String(kSecReturnData)] = true
        searchQuery[String(kSecAttrAccessGroup)] = accessGroup

        var result: CFTypeRef?
        let status = SecItemCopyMatching(searchQuery as CFDictionary, &result)
        try checkMissingAccessControl(status)

        if status == errSecSuccess, let result = result as? Data {
            return result
        }
        if status != errSecItemNotFound {
            throw KeychainError.keychainLocked
        }

        return nil
    }

    func save(data: Data, for accessGroup: String) throws {
        var saveQuery = query
        saveQuery[String(kSecAttrAccessible)] = kSecAttrAccessibleWhenUnlocked
        saveQuery[String(kSecValueData)] = data
        saveQuery[String(kSecAttrAccessGroup)] = accessGroup

        let status = SecItemAdd(saveQuery as CFDictionary, nil)
        try checkMissingAccessControl(status)
        guard status == errSecSuccess else {
            throw KeychainError.queryFailed(status: status)
        }
    }

    func clear() {
        SecItemDelete(query as CFDictionary)
    }

    // MARK: - Helpers

    private var query: [String: Any] {
        [String(kSecAttrService): RDeviceIdentifierConstants.serviceKey,
         String(kSecAttrAccount): RDeviceIdentifierConstants.serviceKey,
         String(kSecClass): kSecClassGenericPassword]
    }

    private func addIfNonExistent() throws -> [String: Any]? {
        var strongQuery = query
        strongQuery[String(kSecAttrAccessible)] = kSecAttrAccessibleWhenUnlocked
        strongQuery[String(kSecReturnAttributes)] = true
        var result: CFTypeRef?
        var status = SecItemCopyMatching(strongQuery as CFDictionary, &result)
        if status == errSecItemNotFound {
            status = SecItemAdd(strongQuery as CFDictionary, &result)
        }
        if status != errSecSuccess {
            throw KeychainError.keychainLocked
        }

        return result as? [String: Any]
    }

    private func checkMissingAccessControl(_ status: OSStatus?) throws {
        // errSecNoAccessForItem is not defined for iOS, only OS X.
        // Normally it would be found in <Security/SecBase.h>.
        if status == errSecNoAccessForItem || status == errSecMissingEntitlement {
            throw KeychainError.accessControl
        }
    }
}

// MARK: - KeychainError

private enum KeychainError: Error {
    case accessControl
    case keychainLocked
    case queryFailed(status: OSStatus)
    case internalError
}

extension KeychainError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .accessControl: return "Your application is lacking the proper keychain-access-group entitlements."
        case .keychainLocked: return "Keychain locked"
        case .queryFailed(let status): return "Keychain query failed with code \(status)"
        case .internalError: return "Internal error"
        }
    }
}
