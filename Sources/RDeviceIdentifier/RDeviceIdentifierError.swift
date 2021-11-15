import Foundation

// MARK: - RDeviceIdentifierError

public enum RDeviceIdentifierError: Error {
    case accessControl
    case appGroupEntitlements(accessGroup: String)
    case keychainLocked
    case keychainQueryFailed(status: OSStatus)
}

extension RDeviceIdentifierError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .accessControl: return "Device must be unlocked first time after restart."
        case .appGroupEntitlements(let accessGroup): return "Your application is lacking keychain-access-group entitlements for \(accessGroup)."
        case .keychainLocked: return "Keychain locked."
        case .keychainQueryFailed(let status): return "Keychain query failed with code \(status)."
        }
    }
}
