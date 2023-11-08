import Foundation
import UIKit

@objc public protocol EventLoggerDeviceable {
    var platform: String? { get }
    var osVersion: String? { get }
    var deviceModel: String? { get }
    var deviceBrand: String? { get }
    var deviceName: String? { get }
}

extension UIDevice: EventLoggerDeviceable {
    public var platform: String? {
        systemName
    }
    
    public var osVersion: String? {
        systemVersion
    }
    
    public var deviceModel: String? {
        deviceModelName()
    }
    
    public var deviceBrand: String? {
        model
    }
    
    public var deviceName: String? {
        deviceModelName()
    }
    
    public func deviceModelName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        return String(bytes: Data(bytes: &systemInfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
}

