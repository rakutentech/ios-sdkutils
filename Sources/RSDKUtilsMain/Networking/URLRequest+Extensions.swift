import Foundation

@objc public extension NSMutableURLRequest {
    func setRASHeaders(for sdkBundle: BundleProtocol, appBundle: BundleProtocol = Bundle.main) {
        let appEnv = EnvironmentInformation(bundle: appBundle)
        let sdkEnv = EnvironmentInformation(bundle: sdkBundle)

        // NOTE: Any changes made below also need to be applied
        // to the extension in URLRequest+StandardHeaders.swift
        setHeader("ras-app-id", appEnv.rasAppId)
        setHeader("ras-device-model", appEnv.deviceModel)
        setHeader("ras-os-version", appEnv.osVersion)
        setHeader("ras-app-name", appEnv.bundleName)
        setHeader("ras-app-version", appEnv.version)
        setHeader("ras-sdk-name", sdkEnv.bundleName)
        setHeader("ras-sdk-version", sdkEnv.version)
    }

    fileprivate func setHeader(_ name: String, _ value: String) {
        if !value.isEmpty {
            setValue(value, forHTTPHeaderField: name)
        }
    }
}
