import UIKit

public extension UIView {

    @discardableResult
    func constraintsFilling(parent: UIView, activate: Bool) -> [NSLayoutConstraint] {
        let constraints = [
            leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            topAnchor.constraint(equalTo: parent.topAnchor),
            bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        ]

        if activate {
            NSLayoutConstraint.activate(constraints)
        }
        return constraints
    }

    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    func isTouchInside(touchPoint point: CGPoint, from: UIView, targetView: UIView?, touchAreaSize: CGFloat) -> Bool {
        guard let targetView = targetView,
              let targetViewSuperview = targetView.superview else {
            return false
        }
        let targetViewCenter = convert(targetView.center, from: targetViewSuperview)
        let targetViewTouchArea = CGRect(origin: targetViewCenter, size: .zero)
            .insetBy(dx: -touchAreaSize / 2.0, dy: -touchAreaSize / 2.0)

        return targetViewTouchArea.contains(point)
    }
}
