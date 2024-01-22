import Foundation
import UIKit

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
        notificationCenter.addObserver(self,
                                       selector: #selector(applicationDidBecomeActive),
                                       name: UIApplication.didBecomeActiveNotification,
                                       object: nil)
    }

    private func stopObserving() {
        notificationCenter.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc func applicationDidBecomeActive() {
        appBecameActiveObserver?()
    }
}
