

import UIKit

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}


extension NSMutableAttributedString {
    
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        
        var attributes = [NSAttributedString.Key: Any]()
        attributes[NSAttributedString.Key.foregroundColor] = UIColor.white
        //        let paragraph = NSMutableParagraphStyle()
        //        paragraph.alignment = .center
        //        attributes[.paragraphStyle] = paragraph
        attributes[NSAttributedString.Key.font] =  UIFont(name: "OpenSans-ExtraBold", size: 14)!
        let boldString = NSMutableAttributedString(string:text, attributes: attributes)
        append(boldString)
        return self
    }
    
    @discardableResult func italic(_ text: String) -> NSMutableAttributedString {
        var attributes = [NSAttributedString.Key: Any]()
        attributes[NSAttributedString.Key.foregroundColor] = UIColor.white
        attributes[NSAttributedString.Key.font] =  UIFont(name: "OpenSans-ExtraBoldItalic", size: 14)!
        let boldString = NSMutableAttributedString(string:text, attributes: attributes)
        append(boldString)
        
        return self
    }
    
    @discardableResult func boldB(_ text: String) -> NSMutableAttributedString {
        
        var attributes = [NSAttributedString.Key: Any]()
        attributes[NSAttributedString.Key.foregroundColor] = UIColor.black.withAlphaComponent(0.75)
        attributes[NSAttributedString.Key.font] =  UIFont(name: "OpenSans-Bold", size: 16)!
        let boldString = NSMutableAttributedString(string:text, attributes: attributes)
        append(boldString)
        return self
    }
    
    @discardableResult func regular(_ text: String) -> NSMutableAttributedString {
        var attributes = [NSAttributedString.Key: Any]()
        attributes[NSAttributedString.Key.foregroundColor] = UIColor.black.withAlphaComponent(0.55)
        attributes[NSAttributedString.Key.font] =  UIFont(name: "OpenSans", size: 16)!
        let boldString = NSMutableAttributedString(string:text, attributes: attributes)
        append(boldString)
        
        return self
    }
}

extension String {
    
    func toBoolVal() -> Bool {
        return self == "1" || self == "true" || self == "yes"
    }
    
    //    func splitStringContainingSpace() -> [String]{
    //        let strs = self.split(" ")
    //        return strs
    //    }
}


//func toJson(data: OptionalDictionary) -> String {
//    do {
//        let jsonData = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
//        var string = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) ?? ""
//        string = string.replacingOccurrences(of: "\n", with: "") as NSString
//        debugPrint(string)
//        string = string.replacingOccurrences(of: "\\", with: "") as NSString
//        debugPrint(string)
//        //            string = string.replacingOccurrences(of: "\"", with: "") as NSString
//        string = string.replacingOccurrences(of: " ", with: "") as NSString
//        debugPrint(string)
//        return string as String
//    }
//    catch let error as NSError{
//        debugPrint(error.description)
//        return ""
//    }
//}


extension Array where Element : Any{
    
    
    func toJson() -> String {
        do {
            let data = self
            
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
            var string = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) ?? ""
            string = string.replacingOccurrences(of: "\n", with: "") as NSString
            debugPrint(string)
            string = string.replacingOccurrences(of: "\\", with: "") as NSString
            debugPrint(string)
            //            string = string.replacingOccurrences(of: "\"", with: "") as NSString
           // string = string.replacingOccurrences(of: " ", with: "") as NSString
            debugPrint(string)
            return string as String
        }
        catch let error as NSError{
            debugPrint(error.description)
            return ""
        }
    }
    
    
    
    func indexOfObject(object : Any) -> NSInteger {
        return (self as NSArray).index(of: object)
    }
    
}

extension String{
    
    
    
    func inserting(separator: String, every n: Int) -> String {
        var result: String = ""
        let characters = Array(self.characters)
        stride(from: 0, to: characters.count, by: n).forEach {
            result += String(characters[$0..<min($0+n, characters.count)])
            if $0+n < characters.count {
                result += separator
            }
        }
        return result
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}


extension String{
    
    func removeSpecialCharacter() -> String {
        
        return  self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined().lowercased()
    }
}

extension String {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    
    func dropLast(_ n: Int = 1) -> String {
        return String(characters.dropLast(n))
    }
    var dropLast: String {
        return dropLast()
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension String {
    
    func serializeJson() -> Any? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}

extension String {
    
    func getPattern() -> String {
        
        let pattern = "###-###-####-######"
        return pattern
    }
    
    func applyPatternOnNumbers(replacmentCharacter: Character, pattern : String) -> String {
        
        //let pattern = getPattern()
        
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            
            guard index < pureNumber.count else { return pureNumber }
            
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}

extension String {

    func flag() -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in self.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }
}


extension Int {
    var boolValue: Bool { return self != 0 }
}


extension UITextField {
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        return false
    }
}

