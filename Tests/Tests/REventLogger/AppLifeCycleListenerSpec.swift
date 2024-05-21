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

            beforeEach {
                mockListener = MockAppLifeCycleListener(listener: AppLifeCycleManager())
            }

            context("when initiate the AppLifeCycleManager") {
                it("should start observing didBecomeActiveNotification") {
                    mockListener.startListening()
                    NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
                    expect(mockListener.isAppBecomeActive).to(beTrue())
                }
            }

            context("when deinit the AppLifeCycleManager") {
                it("should stop observing didBecomeActiveNotification") {
                    NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
                    expect(mockListener.isAppBecomeActive).to(beFalse())
                }
            }
        }
    }
}

final class MockAppLifeCycleListener {
    var isAppBecomeActive = false
    var listener: AppLifeCycleListener

    init(listener: AppLifeCycleListener) {
        self.listener = listener
    }

    func startListening() {
        self.listener.appBecameActiveObserver = { [weak self] in
            self?.isAppBecomeActive = true
        }
    }
}
