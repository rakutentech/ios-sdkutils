import Foundation

@objc public class EnvironmentInformation: NSObject {
    let bundle: BundleProtocol

    var appId: String {
        return bundle.value(for: "RASApplicationIdentifier" as String) ?? bundle.valueNotFound
    }
    var bundleName: String {
        return bundle.value(for: "CFBundleIdentifier" as String) ?? bundle.valueNotFound
    }
    var version: String {
        return bundle.value(for: "CFBundleShortVersionString" as String) ?? bundle.valueNotFound
    }
    var deviceModel: String {
        return bundle.deviceModel()
    }
    var osVersion: String {
        return bundle.osVersion()
    }

    public init(bundle: BundleProtocol = Bundle.main) {
        self.bundle = bundle
    }
}
