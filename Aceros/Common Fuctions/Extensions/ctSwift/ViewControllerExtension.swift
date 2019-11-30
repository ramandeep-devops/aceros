
import UIKit
import Kingfisher


extension UIApplication {
    
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
}

extension UIViewController {
    
    func configureChildViewController(childController: UIViewController, onView: UIView?) {
        var holderView = self.view
        if let onView = onView {
            holderView = onView
        }
        addChild(childController)
        holderView?.addSubview(childController.view)
        //        childController.view.frame = (holderView?.frame) ?? CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height )
        constrainViewEqual(holderView: holderView!, view: childController.view)
        childController.didMove(toParent: self)
    }
    
    
    func constrainViewEqual(holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        //pin 100 points from the top of the super
        let pinTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                        toItem: holderView, attribute: .top, multiplier: 1.0, constant: 0)
        let pinBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                           toItem: holderView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let pinLeft = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal,
                                         toItem: holderView, attribute: .left, multiplier: 1.0, constant: 0)
        let pinRight = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal,
                                          toItem: holderView, attribute: .right, multiplier: 1.0, constant: 0)
        
        holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
    }
    
    
    func presentVc(vc: UIViewController){
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func pushVc(vc: UIViewController){
        self.navigationController?.pushViewController(vc, animated: true )
    }
    
    func popVc(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func presentVcOnSelf(vc: UIViewController){
        self.present(vc, animated: true, completion: nil)
    }
    
    func dismiss(animated: Bool){
        self.dismiss(animated: animated, completion: nil)
    }
    
    
    
    @discardableResult func addChildViewController(withChildViewController childViewController: UIViewController , view: UIView) -> UIViewController {
        // Add Child View Controller
        addChild(childViewController)
        childViewController.beginAppearanceTransition(true, animated: true)
        // Add Child View as Subview
        view.addSubview(childViewController.view)
        // Configure Child View
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Notify Child View Controller
        childViewController.didMove(toParent: self)
        return childViewController
    }
    
    @discardableResult func removeChildViewController(withChildViewController childViewController: UIViewController , view: UIView ) -> UIViewController {
        // Notify Child View Controller
        childViewController.willMove(toParent: nil)
        childViewController.beginAppearanceTransition(false, animated: true)
        // Remove Child View From Superview
        childViewController.view.removeFromSuperview()
        // Notify Child View Controller
        childViewController.removeFromParent()
        return childViewController
    }
    
}


enum Direction { case In, Out }

protocol Dimmable { }

extension UIViewController : Dimmable {}
extension Dimmable where Self: UIViewController {
    
    func dim(direction: Direction, color: UIColor = .black, alpha: Float = 1.0, speed: Double = 0.0) {
        
        switch direction {
        case .In:
            
            // Create and add a dim view
            let dimView = UIView(frame: view.frame)
            dimView.backgroundColor = color
            dimView.alpha = 0.0
            view.addSubview(dimView)
            
            // Deal with Auto Layout
            dimView.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[dimView]|", options: [], metrics: nil, views: ["dimView": dimView]))
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimView]|", options: [], metrics: nil, views: ["dimView": dimView]))
            
            // Animate alpha (the actual "dimming" effect)
            UIView.animate(withDuration: speed) { () -> Void in
                dimView.alpha = CGFloat(alpha)
            }
            
        case .Out:
            UIView.animate(withDuration: speed, animations: { () -> Void in
                self.view.subviews.last?.alpha = CGFloat(alpha)
            }, completion: { (complete) -> Void in
                self.view.subviews.last?.removeFromSuperview()
            })
        }
    }
}

extension Dimmable where Self: UIWindow {
    
    func dim(direction: Direction, color: UIColor = .black, alpha: Float = 0.0, speed: Double = 0.0) {
        
        switch direction {
        case .In:
            
            // Create and add a dim view
            let dimView = UIView(frame: self.frame)
            dimView.backgroundColor = color
            dimView.alpha = 0.0
            self.addSubview(dimView)
            
            // Deal with Auto Layout
            //            dimView.translatesAutoresizingMaskIntoConstraints = false
            //            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[dimView]|", options: [], metrics: nil, views: ["dimView": dimView]))
            //            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[dimView]|", options: [], metrics: nil, views: ["dimView": dimView]))
            
            // Animate alpha (the actual "dimming" effect)
            UIView.animate(withDuration: speed) { () -> Void in
                dimView.alpha = CGFloat(alpha)
            }
            
        case .Out:
            UIView.animate(withDuration: speed, animations: { () -> Void in
                self.subviews.last?.alpha = CGFloat(alpha)
            }, completion: { (complete) -> Void in
                self.subviews.last?.removeFromSuperview()
            })
        }
    }
}


//extension UIApplication {
//
//    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
//        if let navigationController = controller as? UINavigationController {
//            return topViewController(controller: navigationController.visibleViewController)
//        }
//        if let tabController = controller as? UITabBarController {
//            if let selected = tabController.selectedViewController {
//                return topViewController(controller: selected)
//            }
//        }
//        if let presented = controller?.presentedViewController {
//            return topViewController(controller: presented)
//        }
//        return controller
//    }
//}

extension UIImageView {
    
    func setImage( imageThumbNail : String , image: String , isUser: Bool ){
        var name = ""
        var smallName = ""
        var completeName = ""
        if imageThumbNail.contains("google") || imageThumbNail.contains("facebook") {
            name = imageThumbNail
            smallName = imageThumbNail
            completeName = imageThumbNail
        }else {
            completeName = imageThumbNail
            name = imageThumbNail
            smallName = imageThumbNail
        }
        let actualImageUrl =  URL(string: image)
        let smallURL = URL(string: smallName)
        //        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        let placeHolderImg = isUser ? #imageLiteral(resourceName: "ic_user_pic") : #imageLiteral(resourceName: "ic_user_pic")
        self.kf.setImage(with: smallURL, placeholder: placeHolderImg, options: nil , progressBlock: { (_, _) in
            
        }) { (image, _, _, _) in
            guard let _ = image else { return }
            
            let blurredImg = image?.applyBlurWithRadius(0.5, tintColor: UIColor.black.withAlphaComponent(0.4), saturationDeltaFactor: 1.0)
            
            self.image = blurredImg
            self.kf.setImage(with: actualImageUrl, placeholder: blurredImg, options: nil, progressBlock: { (_, _) in
                
            }, completionHandler: { (image, _, _, _) in
                self.image = image
            })
        }
    }
    
    
    func setdarkBackgroundImage( imageThumbNail : String , image: String , isUser: Bool ){
        var name = ""
        var smallName = ""
        var completeName = ""
        if imageThumbNail.contains("google") || imageThumbNail.contains("facebook") {
            name = imageThumbNail
            smallName = imageThumbNail
            completeName = imageThumbNail
        }else {
            completeName = imageThumbNail
            name = imageThumbNail
            smallName = imageThumbNail
        }
        let actualImageUrl =  URL(string: image)
        let smallURL = URL(string: smallName)
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        //        let placeHolderImg = isUser ? #imageLiteral(resourceName: "ic_dp_ph") : #imageLiteral(resourceName: "ic_placeholder")
        self.kf.setImage(with: smallURL, placeholder: nil , options: nil , progressBlock: { (_, _) in
            
        }) { (image, _, _, _) in
            guard let _ = image else { return }
            
            let blurredImg = image?.applyBlurWithRadius(0.5, tintColor: UIColor.black.withAlphaComponent(0.4), saturationDeltaFactor: 1.0)
            
            self.image = blurredImg
            self.kf.setImage(with: actualImageUrl, placeholder: blurredImg, options: nil, progressBlock: { (_, _) in
                
            }, completionHandler: { (image, _, _, _) in
                self.image = image
            })
        }
        
    }
    
    
    
}



extension UIViewController {
    // MARK: - Notifications
    
    ///EZSE: Adds an NotificationCenter with name and Selector
    open func addNotificationObserver(_ name: String, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    ///EZSE: Removes an NSNotificationCenter for name
    open func removeNotificationObserver(_ name: String) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    ///EZSE: Removes NotificationCenter'd observer
    open func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    #if os(iOS)
    
    ///EZSE: Adds a NotificationCenter Observer for keyboardWillShowNotification()
    ///
    /// ⚠️ You also need to implement ```keyboardWillShowNotification(_ notification: Notification)```
    open func addKeyboardWillShowNotification() {
        self.addNotificationObserver(UIResponder.keyboardWillShowNotification.rawValue, selector: #selector(UIViewController.keyboardWillShowNotification(_:)))
    }
    
    ///EZSE:  Adds a NotificationCenter Observer for keyboardDidShowNotification()
    ///
    /// ⚠️ You also need to implement ```keyboardDidShowNotification(_ notification: Notification)```
    public func addKeyboardDidShowNotification() {
        self.addNotificationObserver(UIResponder.keyboardDidShowNotification.rawValue, selector: #selector(UIViewController.keyboardDidShowNotification(_:)))
    }
    
    ///EZSE:  Adds a NotificationCenter Observer for keyboardWillHideNotification()
    ///
    /// ⚠️ You also need to implement ```keyboardWillHideNotification(_ notification: Notification)```
    open func addKeyboardWillHideNotification() {
        self.addNotificationObserver(UIResponder.keyboardWillHideNotification.rawValue, selector: #selector(UIViewController.keyboardWillHideNotification(_:)))
    }
    
    ///EZSE:  Adds a NotificationCenter Observer for keyboardDidHideNotification()
    ///
    /// ⚠️ You also need to implement ```keyboardDidHideNotification(_ notification: Notification)```
    open func addKeyboardDidHideNotification() {
        self.addNotificationObserver(UIResponder.keyboardDidHideNotification.rawValue, selector: #selector(UIViewController.keyboardDidHideNotification(_:)))
    }
    
    ///EZSE: Removes keyboardWillShowNotification()'s NotificationCenter Observer
    open func removeKeyboardWillShowNotification() {
        self.removeNotificationObserver(UIResponder.keyboardWillShowNotification.rawValue)
    }
    
    ///EZSE: Removes keyboardDidShowNotification()'s NotificationCenter Observer
    open func removeKeyboardDidShowNotification() {
        self.removeNotificationObserver(UIResponder.keyboardDidShowNotification.rawValue)
    }
    
    ///EZSE: Removes keyboardWillHideNotification()'s NotificationCenter Observer
    open func removeKeyboardWillHideNotification() {
        self.removeNotificationObserver(UIResponder.keyboardWillHideNotification.rawValue)
    }
    
    ///EZSE: Removes keyboardDidHideNotification()'s NotificationCenter Observer
    open func removeKeyboardDidHideNotification() {
        self.removeNotificationObserver(UIResponder.keyboardDidHideNotification.rawValue)
    }
    
    @objc open func keyboardDidShowNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardDidShowWithFrame(frame)
        }
    }
    
    @objc open func keyboardWillShowNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardWillShowWithFrame(frame)
        }
    }
    
    @objc open func keyboardWillHideNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardWillHideWithFrame(frame)
        }
    }
    
    @objc open func keyboardDidHideNotification(_ notification: Notification) {
        if let nInfo = (notification as NSNotification).userInfo, let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let frame = value.cgRectValue
            keyboardDidHideWithFrame(frame)
        }
    }
    
    open func keyboardWillShowWithFrame(_ frame: CGRect) {
        
    }
    
    open func keyboardDidShowWithFrame(_ frame: CGRect) {
        
    }
    
    open func keyboardWillHideWithFrame(_ frame: CGRect) {
        
    }
    
    open func keyboardDidHideWithFrame(_ frame: CGRect) {
        
    }
    
    //EZSE: Makes the UIViewController register tap events and hides keyboard when clicked somewhere in the ViewController.
    open func hideKeyboardWhenTappedAround(cancelTouches: Bool = false) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = cancelTouches
        view.addGestureRecognizer(tap)
    }
    
    #endif
    
    //EZSE: Dismisses keyboard
    @objc open func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - VC Container
    
    ///EZSE: Returns maximum y of the ViewController
//    open var top: CGFloat {
//        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
//            return visibleViewController.top
//        }
//        if let nav = self.navigationController {
//            if nav.isNavigationBarHidden {
//                return view.top
//            } else {
//                return nav.navigationBar.bottom
//            }
//        } else {
//            return view.top
//        }
//    }
    
    ///EZSE: Returns minimum y of the ViewController
//    open var bottom: CGFloat {
//        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
//            return visibleViewController.bottom
//        }
//        if let tab = tabBarController {
//            if tab.tabBar.isHidden {
//                return view.bottom
//            } else {
//                return tab.tabBar.top
//            }
//        } else {
//            return view.bottom
//        }
//    }
    
    ///EZSE: Returns Tab Bar's height
    open var tabBarHeight: CGFloat {
        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
            return visibleViewController.tabBarHeight
        }
        if let tab = self.tabBarController {
            return tab.tabBar.frame.size.height
        }
        return 0
    }
    
    ///EZSE: Returns Navigation Bar's height
//    open var navigationBarHeight: CGFloat {
//        if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
//            return visibleViewController.navigationBarHeight
//        }
//        if let nav = self.navigationController {
//            return nav.navigationBar.h
//        }
//        return 0
//    }
    
    ///EZSE: Returns Navigation Bar's color
    open var navigationBarColor: UIColor? {
        get {
            if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
                return visibleViewController.navigationBarColor
            }
            return navigationController?.navigationBar.tintColor
        } set(value) {
            navigationController?.navigationBar.barTintColor = value
        }
    }
    
    ///EZSE: Returns current Navigation Bar
    open var navBar: UINavigationBar? {
        return navigationController?.navigationBar
    }
    
    /// EZSwiftExtensions
//    open var applicationFrame: CGRect {
//        return CGRect(x: view.x, y: top, width: view.w, height: bottom - top)
//    }
    
    // MARK: - VC Flow
    
    ///EZSE: Pushes a view controller onto the receiver’s stack and updates the display.
    open func pushVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    open func pushVCNoAnimation(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: false)
    }
    
    ///EZSE: Pops the top view controller from the navigation stack and updates the display.
    open func popVC() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    /// EZSE: Hide or show navigation bar
    public var isNavBarHidden:Bool {
        get {
            return (navigationController?.isNavigationBarHidden)!
        }
        set {
            navigationController?.isNavigationBarHidden = newValue
        }
    }
    
    /// EZSE: Added extension for popToRootViewController
    open func popToRootVC() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    ///EZSE: Presents a view controller modally.
    open func presentVC(_ vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }
    
    ///EZSE: Dismisses the view controller that was presented modally by the view controller.
    open func dismissVC(completion: (() -> Void)? ) {
        dismiss(animated: true, completion: completion)
    }
    
    ///EZSE: Adds the specified view controller as a child of the current view controller.
    open func addAsChildViewController(_ vc: UIViewController, toView: UIView) {
        self.addChild(vc)
        toView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    
    
    
    ///EZSE: Adds image named: as a UIImageView in the Background
    open func setBackgroundImage(_ named: String) {
        let image = UIImage(named: named)
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
    
    ///EZSE: Adds UIImage as a UIImageView in the Background
    @nonobjc func setBackgroundImage(_ image: UIImage) {
        let imageView = UIImageView(frame: view.frame)
        imageView.image = image
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
    
    #if os(iOS)
    
    @available(*, deprecated: 1.9)
    public func hideKeyboardWhenTappedAroundAndCancelsTouchesInView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    #endif
}
