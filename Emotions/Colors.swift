import Foundation
import UIKit

extension UIColor {
        class func colorWithHexString (hexString: NSString!) -> UIColor! {
            if !hexString {
                return nil
            }

        let colorString = hexString.stringByReplacingOccurrencesOfString("#", withString: "").uppercaseString
        var alpha, red, blue, green: CGFloat
        switch countElements(colorString) {
        case 3: // #RGB
        alpha = 1.0
        red = colorComponentFrom(colorString, start: 0, length: 1)
        green = colorComponentFrom(colorString, start: 1, length: 1)
        blue = colorComponentFrom(colorString, start: 2, length: 1)
        case 4: // #ARGB
        alpha = colorComponentFrom(colorString, start: 0, length: 1)
        red = colorComponentFrom(colorString, start: 1, length: 1)
        green = colorComponentFrom(colorString, start: 2, length: 1)
        blue = colorComponentFrom(colorString, start: 3, length: 1)
        case 6: // #RRGGBB
        alpha = 1.0
        red = colorComponentFrom(colorString, start: 0, length: 2)
        green = colorComponentFrom(colorString, start: 2, length: 2)
        blue = colorComponentFrom(colorString, start: 4, length: 2)
        case 8: // #AARRGGBB
        alpha = colorComponentFrom(colorString, start: 0, length: 2)
        red = colorComponentFrom(colorString, start: 2, length: 2)
        green = colorComponentFrom(colorString, start: 4, length: 2)
        blue = colorComponentFrom(colorString, start: 6, length: 2)
        default:
        println("Color value is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB")
        abort()
        }
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    
    }
    class func colorComponentFrom(string: NSString, start: Int, length: Int) -> CGFloat {
        let range = NSMakeRange(start, length)
        let substring = string.substringWithRange(range)
        let fullHex = length == 2 ? substring : "\(substring)\(substring)"
        var hexComponent:UInt32 = 0
        NSScanner.scannerWithString(fullHex).scanHexInt(&hexComponent)
        return CGFloat(Int(hexComponent)) / 255.0;
    }
}