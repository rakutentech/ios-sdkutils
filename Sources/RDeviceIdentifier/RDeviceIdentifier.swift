import UIKit.UIDevice
import CommonCrypto
#if !canImport(RSDKUtils)
import RSDKUtilsMain // Required in SPM version
#endif

// MARK: - Public API

public enum RDeviceIdentifier {
    /// Return a string uniquely identifying the device the application is currently running on.
    ///
    /// - Parameters:
    ///   - service: bundle id of the original app that writes to the keychain (not your host app's bundle id)
    ///   - accessGroup: shared keychain group identifier with App Group entitlements
    /// - Warning: For this method to work, keychain access **MUST** be properly configured first.
    ///            Please refer to internal Analytics SDK README’s Getting Started guide for important
    ///            additional requirements for using this feature correctly.
    ///            Also, the method will fail if the device is not unlocked at the time of calling.
    ///
    /// This value is initially derived from `-[UIDevice identifierForVendor]`, then
    /// stored in a keychain item made accessible to other applications. This has a number of
    /// benefits:
    ///
    /// Feature                                                       | `-[UIDevice identifierForVendor]` | `-[RDeviceIdentifier uniqueDeviceIdentifier]`
    /// ------------------------------------------------------------- | --------------------------------- | ------------------------------------------------
    /// Universally unique                                            | YES                               | YES
    /// Restored from device backups, but only on the original device | YES                               | YES
    /// Survives OS update                                            | YES                               | YES
    /// Survives application update                                   | YES                               | YES
    /// Survives application uninstall                                | YES                               | YES
    /// Survives all applications being uninstalled ¹                 | NO                                | YES
    ///
    /// 1. If an application is reinstalled after all have been uninstalled,
    ///    iOS resets the value to be returned by `-[UIDevice identifierForVendor]`.
    ///
    /// - Warning: Applications built with different application identifier prefixes/bundle seed identifiers, i.e.
    ///          different provisioning profiles, will not produce the same device identifier.
    ///
    /// - Returns: A string uniquely identifying the device the application is currently running on.
    ///         If the keychain is not available (i.e. the device is locked) and no value has been
    ///         retrieved yet, `nil` is returned and the developer should try again when the device
    ///         is unlocked.
    public static func getUniqueDeviceIdentifier(service: String, accessGroup: String) throws -> String {
        let keychain = RDeviceIdentifierKeychain(service: service, accessGroup: accessGroup)
        let prefixedAccessGroup = accessGroup

        // Try to find the device identifier in the keychain.
        // Here we always have a bundle seed id.
        do {
            if let uniqueDeviceIdData = try keychain.search(for: prefixedAccessGroup) {
                // Device id found!
                return uniqueDeviceIdData.hexString
            }
        } catch {
            throw RDeviceIdentifierError.keychainLocked
        }

        // Get identifierForVendor and write it to the keychain.
        // If it succeeds, then assign the result to '_deviceIdData'.
        var deviceIdData: Data?
        guard var idForVendor = UIDevice.current.identifierForVendor?.uuidString else {
            throw RDeviceIdentifierError.accessControl
        }
        // Filter out nil, empty, or zeroed strings (e.g. "00000000-0000-0000-0000-000000000000")
        // We don't have many options here, beside generating an id.
        if !idForVendor.trimmingCharacters(in: CharacterSet(charactersIn: "0-")).isEmpty {
            idForVendor = UUID().uuidString
        }

        if let strData = idForVendor.data(using: .utf8) {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            _ = strData.withUnsafeBytes {
                CC_SHA1($0.baseAddress, CC_LONG(strData.count), &digest)
            }
            deviceIdData = Data(bytes: &digest, count: Int(CC_SHA1_DIGEST_LENGTH))
        }

        guard let deviceIdData = deviceIdData,
              (try? keychain.save(data: deviceIdData, for: prefixedAccessGroup)) != nil else {
              throw RDeviceIdentifierError.keychainLocked
        }

        return deviceIdData.hexString
    }

    /// Return the model identifier of the device the application is currently running on.
    ///
    /// - Returns: The internal model identifier. See [here](https://www.theiphonewiki.com/wiki/Models) for a list of model identifiers.
    public static var modelIdentifier: String {
        // https://opensource.apple.com/source/xnu/xnu-201/bsd/sys/utsname.h.auto.html
        var systemInfo = utsname()
        uname(&systemInfo)
        // utsname.machine is a null terminated C-string
        // make String from a ptr to the first bit (0)
        return String(cString: &systemInfo.machine.0)
    }
}
