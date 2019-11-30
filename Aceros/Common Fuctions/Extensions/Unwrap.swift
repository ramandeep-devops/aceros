
//MARK:- MODULES
import Foundation
import UIKit

//MARK:- EXTENSIONS
extension String: OptionalType {}
extension Int: OptionalType {}
extension Double: OptionalType {}
extension Bool: OptionalType {}
extension Float: OptionalType {}
extension CGFloat: OptionalType {}
extension CGRect: OptionalType {}
extension UIImage: OptionalType {}
extension IndexPath: OptionalType {}
extension UIViewController : OptionalType{}
extension UIView : OptionalType{}

prefix operator /

//unwrapping values
prefix func /<T: OptionalType>( value: T?) -> T {
    guard let validValue = value else { return T() }
    return validValue
}
