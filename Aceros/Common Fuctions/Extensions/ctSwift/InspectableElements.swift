

import UIKit

extension UIButton {
    
    @IBInspectable
    open var exclusiveTouchEnabled : Bool {
        get {
            return self.isExclusiveTouch
        }
        set(value) {
            self.isExclusiveTouch = value
        }
    }
}

extension UIView {
    
    func applyGradient() {
        
        let gradient = CAGradientLayer()
        gradient.name = "gradient"
        gradient.colors = [
            UIColor(red:1, green:1, blue:1, alpha:0.32).cgColor,
            UIColor.white.cgColor
        ]   // your colors go here
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint   = CGPoint(x: 0.5, y: 1)
        gradient.frame = self.bounds
        
        if let oldLayer = self.layer.sublayers?.first , oldLayer.name == "gradient" {
            self.layer.replaceSublayer(oldLayer, with: gradient)
        } else {
            self.layer.insertSublayer(gradient, at: 0)
        }
        
    }
    
    
    @IBInspectable
    open var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set(value) {
            layer.shadowOffset = value
        }
    }
    
    @IBInspectable
    open var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set(value) {
            layer.shadowOpacity = value
        }
    }
    
    @IBInspectable
    open var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set(value) {
            self.layer.masksToBounds = false
            layer.shadowRadius = value
        }
    }
    
    @IBInspectable
    open var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set(value) {
            layer.shadowPath = value
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor {
        get {
            return  UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth : CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat  {
        get {
            return  layer.cornerRadius
        }
        set {
            self.clipsToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor {
        get {
            return  UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    open var isCircularCorner : Bool {
        get {
            return true
        }
        set(value) {
            if value{
                let cornerRadius = min(frame.height/2, frame.width/2)
                layer.cornerRadius = cornerRadius
                layer.masksToBounds = true
            }
        }
    }
    
}







