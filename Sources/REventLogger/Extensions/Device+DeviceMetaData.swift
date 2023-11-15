import UIKit

protocol Deviceable {
    var platform: String { get }
    var osVersion: String { get }
    var deviceModel: String { get }
    var deviceBrand: String { get }
    var deviceName: String { get }
}

extension UIDevice: Deviceable {
    var platform: String {
        systemName
    }

    var osVersion: String {
        systemVersion
    }

    var deviceModel: String {
        deviceModelName()
    }

    var deviceBrand: String {
        model
    }

    var deviceName: String {
        deviceModelName()
    }

    private func deviceModelName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        return String(bytes: Data(bytes: &systemInfo.machine,count: Int(_SYS_NAMELEN)),
                      encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
}
