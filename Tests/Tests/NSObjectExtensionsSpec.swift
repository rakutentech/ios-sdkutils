import Foundation
import Quick
import Nimble
#if os(iOS)
import class UIKit.UIWindow
#endif
#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
#endif

class NSObjectExtensionsSpec: QuickSpec {

    override func spec() {

        describe("NSObjectExtensionsSpec") {

            context("isKind(of:) instance method") {
                let object = NSArray()

                it("will return true if class name matches") {
                    expect(object.isKind(of: "NSArray")).to(beTrue())
                }

                it("will return false if class name does not match") {
                    expect(object.isKind(of: "NSSet")).to(beFalse())
                }

                it("will return false for subclass type") {
                    expect(object.isKind(of: "NSMutableArray")).to(beFalse())
                }

                it("will return true if class name matches base type") {
                    expect(object.isKind(of: "NSObject")).to(beTrue())
                }
            }

            context("isAppleClass() instance method") {
                it("will return true for apple class instance") {
                    let object = NSArray()
                    expect(object.isAppleClass()).to(beTrue())
                }

                it("will return false for non apple class instance") {
                    let object = CustomClass()
                    expect(object.isAppleClass()).to(beFalse())
                }
            }

            context("isApplePrivateClass() instance method") {
                it("will return false for public apple class instance") {
                    let object = NSObject()
                    expect(object.isApplePrivateClass()).to(beFalse())
                }

                it("will return false for non apple class instance") {
                    let object = CustomClass()
                    expect(object.isApplePrivateClass()).to(beFalse())
                }

                it("will return false for non apple class instance that starts with _") {
                    let object = _PrivateCustomClass()
                    expect(object.isApplePrivateClass()).to(beFalse())
                }

                #if os(iOS)
                it("will return true for private apple class instance") {
                    let window = UIWindow()
                    let object = window.value(forKey: "_systemGestureGateForGestures") as! NSObject // _UISystemGestureGateGestureRecognizer
                    expect(object.isApplePrivateClass()).to(beTrue())
                }
                #endif
            }

            context("isNullableObjectEqual() class method") {

                it("will return true for two null objects") {
                    expect(NSObject.isNullableObjectEqual(nil, to: nil)).to(beTrue())
                }

                it("will return true for two identical objects") {
                    let object = NSObject()
                    expect(NSObject.isNullableObjectEqual(object, to: object)).to(beTrue())
                }

                it("will return true for two equal objects") {
                    let object1 = [1] as NSArray
                    let object2 = [1] as NSArray
                    expect(NSObject.isNullableObjectEqual(object1, to: object2)).to(beTrue())
                }

                it("will return false for one null objects") {
                    expect(NSObject.isNullableObjectEqual(nil, to: NSObject())).to(beFalse())
                    expect(NSObject.isNullableObjectEqual(NSObject(), to: nil)).to(beFalse())
                }

                it("will return false if one object is a subclass of the other") {
                    let object1 = NSObject()
                    let object2 = CustomClass()
                    expect(NSObject.isNullableObjectEqual(object1, to: object2)).to(beFalse())
                }
            }
        }
    }
}

private class CustomClass: NSObject { }
private class _PrivateCustomClass: NSObject { }
