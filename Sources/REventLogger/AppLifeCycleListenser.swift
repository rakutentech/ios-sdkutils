import Foundation
import UIKit

protocol AppLifeCycleListener: AnyObject {
    func appDidBecomeActive()
}

final class AppLifeCycleManager {
    weak var listener: AppLifeCycleListener?
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

    @objc private func applicationDidBecomeActive() {
        listener?.appDidBecomeActive()
    }
}
