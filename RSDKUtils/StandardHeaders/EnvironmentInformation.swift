import Foundation

public class EnvironmentInformation: NSObject {
    let bundle: BundleProtocol

    var appId: String {
        return bundle.value(for: "RASApplicationIdentifier" as String) ?? bundle.valueNotFound
    }
    var appName: String {
        return bundle.value(for: "CFBundleIdentifier" as String) ?? bundle.valueNotFound
    }
    var appVersion: String {
        return bundle.value(for: "CFBundleShortVersionString" as String) ?? bundle.valueNotFound
    }
    var deviceModel: String {
        return bundle.deviceModel()
    }
    var osVersion: String {
        return bundle.osVersion()
    }
    var sdkVersion: String {
        return bundle.sdkVersion()
    }

    public init(bundle: BundleProtocol = Bundle.main) {
        self.bundle = bundle
    }
}
