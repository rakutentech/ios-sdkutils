import Foundation

protocol BundleInfoProtocol {
    var valueNotFound: String { get }
    func value(for key: String) -> String?
}

extension Bundle: BundleInfoProtocol {
    var valueNotFound: String {
        ""
    }

    func value(for key: String) -> String? {
        self.object(forInfoDictionaryKey: key) as? String
    }
}
