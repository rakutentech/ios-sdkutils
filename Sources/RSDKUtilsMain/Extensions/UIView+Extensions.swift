import UIKit

public extension UIView {

    /// Creates a collection of constraints that align all four edges of current view to parent view edges.
    /// - Parameter parent: the direct parent view of current view.
    /// - Parameter activate: set to `true` to immediately activate created constraints.
    ///
    ///   Note: Ensure that the view is added as parent's subview before activating the constraints.
    /// - Returns: a collection of four constrants needed to fill parent view.
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

    /// Removes all subviews.
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    /// Checks if given point is enclosed in specified area around view's center.
    /// - Parameter touchPoint: a point to verify.
    /// - Parameter from: the view that defines coordinate space of `touchPoint`.
    /// - Parameter touchAreaSize: size of square area around current view's center.
    /// - Returns: `true` if the point is inside specified area around view's center.
    func isTouchInside(touchPoint: CGPoint, from: UIView, touchAreaSize: CGFloat) -> Bool {
        guard let targetViewSuperview = superview else {
            return false
        }
        let targetViewCenter = convert(center, from: targetViewSuperview)
        let touchPointInTargetView = convert(touchPoint, from: from)
        let targetViewTouchArea = CGRect(origin: targetViewCenter, size: .zero)
            .insetBy(dx: -touchAreaSize / 2.0, dy: -touchAreaSize / 2.0)

        return targetViewTouchArea.contains(touchPointInTargetView)
    }
}
