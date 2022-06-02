#if os(iOS) || os(watchOS)
import UIKit

public extension UIColor {

    /// Convert hexadecimal string to `UIColor` object.
    /// Can fail if string format is invalid.
    ///
    /// Following formats are accepted:
    /// * 0x...
    /// * 0X...
    /// * #...
    ///
    /// String value must be a six-digit/three-byte or eight-digit/four-byte hexadecimal number
    /// - Parameter hexString: Color value in hex format.
    /// - Parameter alpha: Alpha value to append to the `UIColor` object.
    ///                    Replaces existing value in hex string if present.
    convenience init?(hexString string: String, alpha: CGFloat? = nil) {
        var hexString = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        guard let rgbValue = UInt32(hexString, radix: 16) else {
            return nil
        }

        if hexString.count == 8 {
            self.init(
                red: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0,
                green: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
                blue: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
                alpha: alpha ?? CGFloat(rgbValue & 0x000000FF) / 255.0
            )
        } else if hexString.count == 6 {
            self.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: alpha ?? 1.0
            )
        } else {
            return nil
        }
    }

    /// Checks if two colors are equal by comparing their RGBA components.
    /// This method is color space agnostic (e.g. HSV color will be treated as RGB).
    /// - Parameter anotherColor: A color to compare with.
    /// - Returns: `true` if both colors have the same RGBA values.
    func isRGBAEqual(to anotherColor: UIColor) -> Bool {
        var rgba1: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
        var rgba2: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)

        getRed(&rgba1.r, green: &rgba1.g, blue: &rgba1.b, alpha: &rgba1.a)
        anotherColor.getRed(&rgba2.r, green: &rgba2.g, blue: &rgba2.b, alpha: &rgba2.a)

        return rgba1 == rgba2
    }
}
#endif
