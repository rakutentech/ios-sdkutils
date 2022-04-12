import Quick
import Nimble
import UIKit
#if canImport(RSDKUtils)
@testable import RSDKUtils // Cocoapods version
#else
@testable import RSDKUtilsMain
#endif

class UIColorExtensionsSpec: QuickSpec {

    override func spec() {

        describe("UIColor+Extensions") {

            context("when calling hexString method") {

                it("will return nil when string is too long") {
                    let color = UIColor(hexString: "FFFFFFFFF")
                    expect(color).to(beNil())
                }

                it("will return nil for malformed hex format") {
                    let color = UIColor(hexString: "33221aa")
                    expect(color).to(beNil())
                }

                it("will return nil when string is too short") {
                    let color = UIColor(hexString: "FFFFF")
                    expect(color).to(beNil())
                }

                it("will return nil when string is empty") {
                    let color = UIColor(hexString: "")
                    expect(color).to(beNil())
                }

                it("will return nil when string has unsupported characters") {
                    var color = UIColor(hexString: "FFHFFF")
                    expect(color).to(beNil())
                    color = UIColor(hexString: "-FFFFF")
                    expect(color).to(beNil())
                }

                it("will return color") {
                    let color = UIColor(hexString: "000000", alpha: 0.7)
                    var alpha: CGFloat = 0
                    color?.getRed(nil, green: nil, blue: nil, alpha: &alpha)
                    expect(alpha).to(equal(0.7))
                }

                it("will return color with alpha value in hex string") {
                    let color = UIColor(hexString: "332211aa")
                    expect(color).to(equal(UIColor(red: 51/255, green: 34/255, blue: 17/255, alpha: 170/255)))
                }

                it("will return color overriding alpha in hex string") {
                    let color = UIColor(hexString: "332211aa", alpha: 0.1)
                    expect(color).to(equal(UIColor(red: 51/255, green: 34/255, blue: 17/255, alpha: 0.1)))
                }

                it("will return full white color with FFFFFF") {
                    let color = UIColor(hexString: "FFFFFF")
                    expect(color).to(equal(UIColor.whiteRGB))
                }

                it("will return full black color with 000000") {
                    let color = UIColor(hexString: "000000")
                    expect(color).to(equal(UIColor.blackRGB))
                }

                it("will return expected color for given value") {
                    let color = UIColor(hexString: "FDAC10")
                    expect(color).to(equal(UIColor(red: 253.0/255.0,
                                                   green: 172.0/255.0,
                                                   blue: 16.0/255.0,
                                                   alpha: 1.0)))
                }

                it("will return expected color trimming whitespace characters from the string") {
                    let color = UIColor(hexString: "\n #FFFFFF\t")
                    expect(color).to(equal(UIColor.whiteRGB))
                }

                it("will return expected color even if string has are lower or upper case letters") {
                    let color = UIColor(hexString: "FFffFf")
                    expect(color).to(equal(UIColor.whiteRGB))
                }

                it("will return expected color for string with # prefix") {
                    let color = UIColor(hexString: "#FFFFFF")
                    expect(color).to(equal(UIColor.whiteRGB))
                }

                it("will return expected color for string without # prefix") {
                    let color = UIColor(hexString: "FFFFFF")
                    expect(color).to(equal(UIColor.whiteRGB))
                }
            }

            context("when calling isRGBAEqual method") {
                it("should return true for the same colors") {
                    expect(UIColor.white.isRGBAEqual(to: .white)).to(beTrue())
                }

                it("should return true for the same colors but in different color spaces") {
                    let grayscaleColor = UIColor(white: 0.2, alpha: 0.8)
                    let rgbColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.8)
                    let hsvColor = UIColor(hue: 0, saturation: 0, brightness: 0.2, alpha: 0.8)

                    expect(grayscaleColor.isRGBAEqual(to: rgbColor)).to(beTrue())
                    expect(rgbColor.isRGBAEqual(to: hsvColor)).to(beTrue())
                }

                it("should return false for different colors") {
                    expect(UIColor.green.isRGBAEqual(to: .blue)).to(beFalse())
                }

                it("should return false for the same colors but with different alpha falue") {
                    expect(UIColor.white.isRGBAEqual(to: .white.withAlphaComponent(0.3))).to(beFalse())
                }
            }
        }
    }
}

private extension UIColor {
    static var blackRGB: UIColor {
        return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
    static var whiteRGB: UIColor {
        return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
