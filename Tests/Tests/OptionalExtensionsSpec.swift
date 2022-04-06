import Foundation
import Quick
import Nimble
import UIKit
import CoreLocation.CLLocation
#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
#endif

class OptionalExtensionsSpec: QuickSpec {

    override func spec() {

        describe("Optional+NSObject Extensions") {

            context("isKind(of:) instance method") {
                let object: NSArray? = NSArray()

                it("will return true if class name matches") {
                    expect(object.isKind(of: "NSArray")).to(beTrue())
                }

                it("will return false if class name does not match") {
                    expect(object.isKind(of: "NSSet")).to(beFalse())
                }

                it("will return true if class name matches base type") {
                    expect(object.isKind(of: "NSObject")).to(beTrue())
                }

                it("will return false for subclass type") {
                    expect(object.isKind(of: "NSMutableArray")).to(beFalse())
                }

                it("will return false if object is nil") {
                    let object: NSArray? = nil
                    expect(object.isKind(of: "NSArray")).to(beFalse())
                }
            }

            context("isMember(of:) instance method") {
                let object: UIView? = UIView()

                it("will return true if class type matches") {
                    expect(object.isMember(of: UIView.self)).to(beTrue())
                }

                it("will return false if class does not match") {
                    expect(object.isMember(of: NSArray.self)).to(beFalse())
                }

                it("will return false for subclass type") {
                    expect(object.isMember(of: UIButton.self)).to(beFalse())
                }

                it("will return false for superclass") {
                    expect(object.isMember(of: NSObject.self)).to(beFalse())
                }

                it("will return false if object is nil") {
                    let object: UIView? = nil
                    expect(object.isMember(of: UIView.self)).to(beFalse())
                }
            }

            context("isAppleClass() instance method") {
                it("will return true for apple class instance") {
                    let object: NSArray? = NSArray()
                    expect(object.isAppleClass()).to(beTrue())
                }

                it("will return false for non apple class instance") {
                    let object: CustomClass? = CustomClass()
                    expect(object.isAppleClass()).to(beFalse())
                }

                it("will return false if object is nil") {
                    let object: NSArray? = nil
                    expect(object.isAppleClass()).to(beFalse())
                }
            }

            context("isApplePrivateClass() instance method") {
                it("will return false for public apple class instance") {
                    let object: NSObject? = NSObject()
                    expect(object.isApplePrivateClass()).to(beFalse())
                }

                it("will return false for non apple class instance") {
                    let object: CustomClass? = CustomClass()
                    expect(object.isApplePrivateClass()).to(beFalse())
                }

                it("will return false for non apple class instance that starts with _") {
                    let object: _PrivateCustomClass? = _PrivateCustomClass()
                    expect(object.isApplePrivateClass()).to(beFalse())
                }

                it("will return true for private apple class instance") {
                    let window = UIWindow()
                    let object = window.value(forKey: "_systemGestureGateForGestures") as? NSObject // _UISystemGestureGateGestureRecognizer
                    expect(object).toNot(beNil())
                    expect(object.isApplePrivateClass()).to(beTrue())
                }

                it("will return false if object is nil") {
                    let window = UIWindow()
                    var object = window.value(forKey: "_systemGestureGateForGestures") as? NSObject
                    object = nil
                    expect(object.isApplePrivateClass()).to(beFalse())
                }
            }

            context("safeHashValue instance variable") {

                it("will return expected hashValue") {
                    let object: CustomClass? = CustomClass()
                    expect(object.safeHashValue).to(equal(100))
                }

                it("will return 0 if object is nil") {
                    let object: CustomClass? = nil
                    expect(object.safeHashValue).to(equal(0))
                }
            }
        }

        describe("Optional+String Extensions") {
            context("safeHashValue instance variable") {
                it("will return expected hashValue") {
                    let object: String? = "hello"
                    expect(object.safeHashValue).to(equal("hello".hashValue))
                }

                it("will return 0 if object is nil") {
                    let object: String? = nil
                    expect(object.safeHashValue).to(equal(0))
                }
            }
            context("isEmpty instance variable") {
                it("will return false if Wrapped is String") {
                    let object: String? = "hello"
                    expect(object.isEmpty).to(beFalse())
                }
                it("will return true if object is nil") {
                    let object: String? = nil
                    expect(object.isEmpty).to(beTrue())
                }
            }
        }

        describe("Optional+Date Extensions") {
            context("safeHashValue instance variable") {
                it("will return expected hashValue") {
                    let object: Date? = Date(timeIntervalSince1970: 0)
                    expect(object.safeHashValue).to(equal(Date(timeIntervalSince1970: 0).hashValue))
                }

                it("will return 0 if object is nil") {
                    let object: Date? = nil
                    expect(object.safeHashValue).to(equal(0))
                }
            }
        }

        describe("Optional+CLLocation Extensions") {
            context("safeHashValue instance variable") {
                it("will return expected hashValue") {
                    let object: CLLocation? = CLLocation(latitude: 35.6144, longitude: 139.6264)
                    expect(object.safeHashValue).to(equal(CLLocation(latitude: 35.6144, longitude: 139.6264).description.hashValue))
                }

                it("will return 0 if object is nil") {
                    let object: CLLocation? = nil
                    expect(object.safeHashValue).to(equal(0))
                }
            }
        }
    }
}

private class CustomClass: NSObject {
    override var hash: Int { 100 }
}
private class _PrivateCustomClass: NSObject { }
