import Foundation
#if os(iOS)
import UIKit
#endif

protocol AppLifeCycleListener {
    var appBecameActiveObserver: (() -> Void)? { get set }
}

final class AppLifeCycleManager: AppLifeCycleListener {
    var appBecameActiveObserver: (() -> Void)?
    private let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        startObserving()
    }

    deinit {
        stopObserving()
    }

    private func startObserving() {
        #if os(iOS)
        notificationCenter.addObserver(self,
                                       selector: #selector(applicationDidBecomeActive),
                                       name: UIApplication.didBecomeActiveNotification,
                                       object: nil)
        #endif
    }

    private func stopObserving() {
        #if os(iOS)
        notificationCenter.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        #endif
    }

    @objc func applicationDidBecomeActive() {
        appBecameActiveObserver?()
    }
}
