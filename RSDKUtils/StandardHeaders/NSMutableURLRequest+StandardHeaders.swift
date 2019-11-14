import Foundation

@objc public extension NSMutableURLRequest {
    func setRASHeaders(for sdk: String) {
        let env = EnvironmentInformation()

        // NOTE: Any changes made below also need to be applied
        // to the extension in URLRequest+StandardHeaders.swift
        setHeader("ras-app-id", env.appId)
        setHeader("ras-device-model", env.deviceModel)
        setHeader("ras-os-version", env.osVersion)
        setHeader("ras-sdk-name", sdk)
        setHeader("ras-sdk-version", env.sdkVersion)
        setHeader("ras-app-name", env.appName)
        setHeader("ras-app-version", env.appVersion)
    }

    fileprivate func setHeader(_ name: String, _ value: String) {
        if value.count > 0 {
            setValue(value, forHTTPHeaderField: name)
        }
    }
}
