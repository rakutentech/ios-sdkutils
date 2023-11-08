import Foundation
import Quick
import Nimble
import UIKit

@testable import REventLogger

class DeviceMetaDataSpec: QuickSpec {

    override func spec() {
        describe("check device info") {
            let deviceInfoMock = DeviceInfoMock()
            DeviceInfo.deviceBundle = deviceInfoMock
            
            context("validate device model") {
                it("should return expected device model") {
                    expect(DeviceInfo.deviceBrand).to(equal("iPhone"))
                }
            }

            context("validate appVersion") {
                it("should return expected OS Version of device") {
                    expect(DeviceInfo.osVersion).to(equal("iOS 17"))
                }
            }
            
            context("validate appName") {
                it("should return expected appVersion") {
                    expect(DeviceInfo.platform).to(equal("iOS"))
                }
            }
        }
    }
}

class DeviceInfoMock: UIDevice {
    override var model: String {
        "iPhone"
    }
    override var systemName: String {
        "iOS"
    }
    override var systemVersion: String {
        "iOS 17"
    }    
}

