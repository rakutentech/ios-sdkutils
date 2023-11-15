import UIKit

struct DeviceInfo {
    static var deviceBundle: Deviceable = UIDevice.current

    static var platform: String? {
        deviceBundle.platform
    }

    static var osVersion: String? {
        deviceBundle.osVersion
    }

    static var deviceModel: String? {
        deviceBundle.deviceModel
    }

    static var deviceBrand: String? {
        deviceBundle.deviceBrand
    }

    static var deviceName: String? {
        deviceBundle.deviceName
    }
}
