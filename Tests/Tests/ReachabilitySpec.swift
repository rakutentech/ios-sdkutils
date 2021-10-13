import Foundation
import Quick
import Nimble
import struct SystemConfiguration.SCNetworkReachabilityFlags
#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
#endif

class ReachabilitySpec: QuickSpec {

    override func spec() {

        describe("Reachablity") {

            context("init") {

                it("will return nil for empty hostname") {
                    let instance = Reachability(hostname: "")
                    expect(instance).to(beNil())
                }

                it("will return nil for file:// url") {
                    let instance = Reachability(url: Bundle.main.bundleURL)
                    expect(instance).to(beNil())
                }

                it("will return nil for invalid url") {
                    let instance = Reachability(url: URL(string: "aa")!)
                    expect(instance).to(beNil())
                }

                it("will return an instance for valid http url") {
                    let instance = Reachability(url: URL(string: "http://localhost:6789/")!)
                    expect(instance).toNot(beNil())
                }

                it("will return an instance for valid https url") {
                    let instance = Reachability(url: URL(string: "https://google.com/")!)
                    expect(instance).toNot(beNil())
                    sleep(5)
                }
            }

            context("connection available") {
                var reachability: Reachability!

                beforeEach {
                    reachability = Reachability(url: URL(string: "http://localhost")!)
                }

                it("will return proper flag") {
                    expect(reachability.flags).to(equal([SCNetworkReachabilityFlags.reachable]))
                    expect(reachability.description).to(equal("-R -------"))
                }

                it("will return proper connection status") {
                    expect(reachability.connection).to(equal(.wifi))
                }

                it("will notify observers") {
                    let observer = Observer()
                    reachability.addObserver(observer)
                    expect(observer.currentStatus).toEventually(equal(.wifi))
                }
            }

            // unfortunately there's no way to test unavailable connection on simulator,
            // and therefore test observer notifications
        }
    }
}

private class Observer: ReachabilityObserver {

    var currentStatus: Reachability.Connection?

    func reachabilityChanged(_ reachability: ReachabilityType) {
        currentStatus = reachability.connection
    }
}
