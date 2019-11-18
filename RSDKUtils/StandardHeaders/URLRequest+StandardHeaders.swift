import Foundation

public extension URLRequest {
    mutating func setRASHeaders(for sdkBundle: BundleProtocol, appBundle: BundleProtocol = Bundle.main) {
        let appEnv = EnvironmentInformation(bundle: appBundle)
        let sdkEnv = EnvironmentInformation(bundle: sdkBundle)

        // NOTE: Any changes made below also need to be applied
        // to the extension in NSMutableURLRequest+StandardHeaders.swift
        setHeader("ras-app-id", appEnv.appId)
        setHeader("ras-device-model", appEnv.deviceModel)
        setHeader("ras-os-version", appEnv.osVersion)
        setHeader("ras-app-name", appEnv.bundleName)
        setHeader("ras-app-version", appEnv.version)
        setHeader("ras-sdk-name", sdkEnv.bundleName)
        setHeader("ras-sdk-version", sdkEnv.version)
    }

    fileprivate mutating func setHeader(_ name: String, _ value: String) {
        if value.count > 0 {
            setValue(value, forHTTPHeaderField: name)
        }
    }
}
