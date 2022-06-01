#if os(iOS)
import Foundation
import Quick
import Nimble
import UIKit
#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
#endif

class ViewExtensionsSpec: QuickSpec {

    override func spec() {

        describe("UIView extensions") {

            context("isTouchInside") {

                var targetView: UIView!
                var superview: UIView!

                beforeEach {
                    // setting up a target view inside a 100x100 rectangle in the center
                    targetView = UIView(frame: .init(origin: .zero, size: CGSize(width: 40, height: 40)))
                    superview = UIView(frame: .init(origin: .zero, size: CGSize(width: 100, height: 100)))
                    superview.addSubview(targetView)
                    targetView.center = CGPoint(x: superview.bounds.midX, y: superview.bounds.midY)
                }

                it("should return true if touch point is inside targetView") {
                    let result = targetView.isTouchInside(touchPoint: targetView.center,
                                                          from: superview,
                                                          touchAreaSize: 60)
                    expect(result).to(beTrue())
                }

                it("should return true if touch point is outside targetView but within limit of touchAreaSize") {
                    let result = targetView.isTouchInside(touchPoint: CGPoint(x: 25, y: 25),
                                                          from: superview,
                                                          touchAreaSize: 60)
                    expect(result).to(beTrue())
                }

                it("should return false if the view doesn't have superview") {
                    targetView.removeFromSuperview()
                    let result = targetView.isTouchInside(touchPoint: targetView.center,
                                                          from: superview,
                                                          touchAreaSize: 60)
                    expect(result).to(beFalse())
                }

                it("should return false if touch point is inside targetView but it doesn't fit in touchAreaSize") {
                    let result = targetView.isTouchInside(touchPoint: CGPoint(x: 60, y: 60),
                                                          from: superview,
                                                          touchAreaSize: 10)
                    expect(result).to(beFalse())
                }
            }
        }
    }
}
#endif
