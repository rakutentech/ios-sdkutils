import UIKit

protocol DeviceSupportProtocol {
    var systemName: String { get }
    var systemVersion: String { get }
    var model: String { get }
}

extension UIDevice: DeviceSupportProtocol {}
