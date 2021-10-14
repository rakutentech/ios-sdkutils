import Foundation
import Quick
import Nimble
#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
#endif

class StandardHeadersSpec: QuickSpec {
    override func spec() {
        let url = URL(string: "https://www.rakuten.com")

        let mockAppBundle = BundleMock()
        mockAppBundle.mockRASAppId = "myRASAppId"
        mockAppBundle.mockBundleId = "myAppName"
        mockAppBundle.mockDeviceModel = "myDeviceModel"
        mockAppBundle.mockOsVersion = "myOsVersion"
        mockAppBundle.mockBundleVersion = "myAppVersion"
        mockAppBundle.mockNotFound = "not_found"

        let mockSDKBundle = BundleMock()
        mockSDKBundle.mockRASAppId = "myRASAppId"
        mockSDKBundle.mockBundleId = "mySDKName"
        mockSDKBundle.mockDeviceModel = "myDeviceModel"
        mockSDKBundle.mockOsVersion = "myOsVersion"
        mockSDKBundle.mockBundleVersion = "mySDKVersion"
        mockSDKBundle.mockNotFound = "not_found"

        let rasHeaders = [
            "ras-sdk-name": "mySDKName",
            "ras-app-name": "myAppName",
            "ras-os-version": "myOsVersion",
            "ras-device-model": "myDeviceModel",
            "ras-app-version": "myAppVersion",
            "ras-app-id": "myRASAppId",
            "ras-sdk-version": "mySDKVersion"
        ]

        context("objc NSMutableURLRequest setRASHeaders") {
            it("sets the expected RAS headers when there are no existing headers") {
                let request = NSMutableURLRequest(url: url!)

                request.setRASHeaders(for: mockSDKBundle, appBundle: mockAppBundle)

                expect(request.allHTTPHeaderFields).to(equal(rasHeaders))
            }

            it("sets the expected RAS headers when there are headers already") {
                let request = NSMutableURLRequest(url: url!)
                request.setValue("myVal", forHTTPHeaderField: "myHeader")

                request.setRASHeaders(for: mockSDKBundle, appBundle: mockAppBundle)

                expect(request.allHTTPHeaderFields?["ras-sdk-version"]).to(equal("mySDKVersion"))
            }

            it("keeps the current headers when it sets the RAS headers") {
                let request = NSMutableURLRequest(url: url!)
                request.setValue("myVal", forHTTPHeaderField: "myHeader")

                request.setRASHeaders(for: mockSDKBundle, appBundle: mockAppBundle)

                expect(request.allHTTPHeaderFields?["myHeader"]).to(equal("myVal"))
            }
        }
    }
}
