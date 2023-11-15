import Foundation
import Quick
import Nimble
import UIKit

@testable import REventLogger

final class DeviceInfoSpec: QuickSpec {

    override func spec() {
        describe("check device info") {
            let deviceInfoMock = DeviceInfoMock()
            DeviceInfo.deviceBundle = deviceInfoMock

            context("validate device brand") {
                it("should return expected device brand") {
                    expect(DeviceInfo.deviceBrand).to(equal("iPhone"))
                }
            }

            context("validate osVersion") {
                it("should return expected OS Version of device") {
                    expect(DeviceInfo.osVersion).to(equal("iOS 17"))
                }
            }

            context("validate platform") {
                it("should return expected platform") {
                    expect(DeviceInfo.platform).to(equal("iOS"))
                }
            }
        }
    }
}

final class DeviceInfoMock: UIDevice {
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
