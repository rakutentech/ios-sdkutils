import UIKit.UIDevice
import CommonCrypto
#if !canImport(RSDKUtils)
import RLogger // Required in SPM version
#endif

@objc public final class RDeviceIdentifier: NSObject {
    private static let keychain = RDeviceIdentifierKeychain()
    private static var _uniqueDeviceIdentifier: String?

    // MARK: - Public API

    /// Return a string uniquely identifying the device the application is currently running on.
    ///
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
    @objc public static var uniqueDeviceIdentifier: String? {
        // If we already have a value, return it.
        if let _uniqueDeviceIdentifier = _uniqueDeviceIdentifier {
            return _uniqueDeviceIdentifier
        }

        var accessGroup: String?
        do {
            if let (internalAccessGroup, defaultAccessGroup) = try keychain.getAccessGroups() {
                accessGroup = internalAccessGroup
                checkKeychainAccessGroupOrder(defaultAccessGroup)
            }
        } catch {
            // Keychain is not available
            RLogger.debug(message: "Keychain access failed")
            return nil
        }

        // Try to clean things up
        reset()

        // Try to find the device identifier in the keychain.
        // Here we always have a bundle seed id.
        do {
            if let accessGroup = accessGroup, let uniqueDeviceIdData = try keychain.search(for: accessGroup) {
                // Device id found!
                _uniqueDeviceIdentifier = uniqueDeviceIdData.hexString
                return _uniqueDeviceIdentifier
            }
        } catch {
            // Keychain problem
            RLogger.debug(message: "Keychain access failed")
            return nil
        }

        // Get identifierForVendor and write it to the keychain.
        // If it succeeds, then assign the result to '_deviceIdData'.
        var deviceIdData: Data?
        guard var idForVendor = UIDevice.current.identifierForVendor?.uuidString else {
            RLogger.debug(message: "Device must be unlocked first time after restart")
            return nil
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
              let accessGroup = accessGroup,
              (try? keychain.save(data: deviceIdData, for: accessGroup)) != nil else {
            RLogger.debug(message: "Keychain access failed")
            return nil
        }

        _uniqueDeviceIdentifier = deviceIdData.hexString
        return _uniqueDeviceIdentifier
}

    /// Return the model identifier of the device the application is currently running on.
    ///
    /// - Returns: The internal model identifier. See [here](https://www.theiphonewiki.com/wiki/Models) for a list of model identifiers.
    @objc public static var modelIdentifier: String {
        // https://opensource.apple.com/source/xnu/xnu-201/bsd/sys/utsname.h.auto.html
        var systemInfo = utsname()
        uname(&systemInfo)
        // utsname.machine is a null terminated C-string
        // make String from a ptr to the first bit (0)
        return String(cString: &systemInfo.machine.0)
    }

    // MARK: - Helpers

    private static func checkKeychainAccessGroupOrder(_ defaultAccessGroup: String) {
        if let firstStopIndex = defaultAccessGroup.firstIndex(of: ".") {
            let indexAfterStop = defaultAccessGroup.index(after: firstStopIndex)
            let bundleId = String(defaultAccessGroup[indexAfterStop...])
            if RDeviceIdentifierConstants.keychainAccessGroup == bundleId {
                assertionFailure("\(RDeviceIdentifierConstants.keychainAccessGroup) is your default access group." +
                        "Make sure your application's bundle identifier is the first entry of `keychain-access-groups` in your entitlements!")
            }
        }
    }

    static func reset() {
        _uniqueDeviceIdentifier = nil
        keychain.clear()
    }
}
