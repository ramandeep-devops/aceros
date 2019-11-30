//
//  CustomTabbar.swift


import UIKit

class CustomTabbar: UITabBar {

    @IBInspectable
    var height: CGFloat = 0.0
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        
        var sizeThatFits = super.sizeThatFits(size)
        
        guard let window = UIApplication.shared.keyWindow else {
            sizeThatFits.height = height
            return sizeThatFits
        }
        if #available(iOS 11.0, *) {
            sizeThatFits.height = height + window.safeAreaInsets.bottom
        } else {
            // Fallback on earlier versions
            sizeThatFits.height = height
        }
        return sizeThatFits
    }

}
