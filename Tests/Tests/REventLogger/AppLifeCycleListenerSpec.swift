import Quick
import Nimble

#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import REventLogger
#endif

final class AppLifeCycleListenerSpec: QuickSpec {
    override func spec() {
        describe("AppLifeCycleListener") {
            var mockListener: MockAppLifeCycleListener!
            var appLifeCycleManager: AppLifeCycleManager?

            beforeEach {
                mockListener = MockAppLifeCycleListener()
                appLifeCycleManager = AppLifeCycleManager()
                appLifeCycleManager?.listener = mockListener
            }

            context("when initiate the AppLifeCycleManager") {
                it("should start observing didBecomeActiveNotification") {
                    NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
                    expect(mockListener.isAppBecomeActive).to(beTrue())
                }
            }

            context("when deinit the AppLifeCycleManager") {
                it("should stop observing didBecomeActiveNotification") {
                    appLifeCycleManager = nil
                    NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
                    expect(mockListener.isAppBecomeActive).to(beFalse())
                }
            }
        }
    }
}

final class MockAppLifeCycleListener: AppLifeCycleListener {
    var isAppBecomeActive = false
    func appDidBecomeActive() {
        isAppBecomeActive = true
    }
}
