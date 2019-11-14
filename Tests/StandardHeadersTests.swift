import Quick
import Nimble
@testable import RSDKUtils

class StandardHeadersSpec: QuickSpec {
    override func spec() {
        let url = URL(string: "https://www.rakuten.com")

        let mockBundle = BundleMock()
        mockBundle.mockAppId = "myAppId"
        mockBundle.mockAppName = "myAppName"
        mockBundle.mockAppVersion = "myAppVersion"
        mockBundle.mockDeviceModel = "myDeviceModel"
        mockBundle.mockOsVersion = "myOsVersion"
        mockBundle.mockSdkVersion = "mySDKVersion"
        mockBundle.mockNotFound = "not_found"

        let environment = EnvironmentInformation(bundle: mockBundle)

        let rasHeaders = [
            "ras-sdk-name": "mySDK",
            "ras-app-name": "myAppName",
            "ras-os-version": "myOsVersion",
            "ras-device-model": "myDeviceModel",
            "ras-app-version": "myAppVersion",
            "ras-app-id": "myAppId",
            "ras-sdk-version": "mySDKVersion"
        ]

        context("URLRequest setRASHeaders") {
            it("sets the expected RAS headers when there are no existing headers") {
                var request = URLRequest(url: url!)

                request.setRASHeaders(for: "mySDK", env: environment)

                expect(request.allHTTPHeaderFields).to(equal(rasHeaders))
            }

            it("sets the expected RAS SDK version header when there are headers already") {
                var request = URLRequest(url: url!)
                request.setValue("myVal", forHTTPHeaderField: "myHeader")

                request.setRASHeaders(for: "mySDK", env: environment)

                expect(request.allHTTPHeaderFields?["ras-sdk-version"]).to(equal("mySDKVersion"))
            }

            it("keeps the current headers when it sets the RAS headers") {
                var request = URLRequest(url: url!)
                request.setValue("myVal", forHTTPHeaderField: "myHeader")

                request.setRASHeaders(for: "mySDK", env: environment)

                expect(request.allHTTPHeaderFields?["myHeader"]).to(equal("myVal"))
            }
        }

        context("objc NSMutableURLRequest setRASHeaders") {
            it("sets the expected RAS headers when there are no existing headers") {
                let request = NSMutableURLRequest(url: url!)

                request.setRASHeaders(for: "mySDK", env: environment)

                expect(request.allHTTPHeaderFields).to(equal(rasHeaders))
            }

            it("sets the expected RAS headers when there are headers already") {
                let request = NSMutableURLRequest(url: url!)
                request.setValue("myVal", forHTTPHeaderField: "myHeader")

                request.setRASHeaders(for: "mySDK", env: environment)

                expect(request.allHTTPHeaderFields?["ras-sdk-version"]).to(equal("mySDKVersion"))
            }

            it("keeps the current headers when it sets the RAS headers") {
                let request = NSMutableURLRequest(url: url!)
                request.setValue("myVal", forHTTPHeaderField: "myHeader")

                request.setRASHeaders(for: "mySDK", env: environment)

                expect(request.allHTTPHeaderFields?["myHeader"]).to(equal("myVal"))
            }
        }
    }
}
