import Foundation

@objc public class EnvironmentInformation: NSObject {

    static let isRunningTests = ProcessInfo.processInfo.environment["XCTestBundlePath"] != nil

    let bundle: BundleProtocol

    var bundleName: String {
        return bundle.value(for: "CFBundleIdentifier") ?? bundle.valueNotFound
    }
    var version: String {
        return bundle.value(for: "CFBundleShortVersionString") ?? bundle.valueNotFound
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
