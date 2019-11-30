
import UIKit

extension Array where Element: Equatable {
    func removingDuplicates() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension UISearchBar{
    
    func setMagnifyingGlassColorTo(color: UIColor){
        // Search Icon
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = color
    }
}
    
extension UISearchBar {
    
    private func getViewElement<T>(type: T.Type) -> T? {
        
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    func setTextFieldColor(color: UIColor) {
        
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.textColor = color
                textField.layer.backgroundColor = UIColor.clear.cgColor
                textField.layer.cornerRadius = 6
                textField.placeHolderColor = UIColor.white
            case .prominent, .default:
                textField.backgroundColor = color
            }
            
        }
    }
    
}

extension UISearchBar {
    
    func change(textFont : UIFont?) {
        
        for view : UIView in (self.subviews[0]).subviews {
            
            if let textField = view as? UITextField {
                
                textField.font = UIFont(name: "Gilroy-Regular", size: 8.0)
            }
        }
    } }
