

import UIKit
import Photos
import PhotosUI
//import Material
import AVFoundation
import SwiftMessages
import NVActivityIndicatorView

extension Theme {
    var title:String {
        switch self {
        case .error: return "Error"
        case .success: return "Success"
        case .warning: return "Warning"
        case .info: return "Alert"
        }
    }
}

class UtilityFunctions : NVActivityIndicatorViewable {
    
    class func makeToast(text : String?,type : Theme, duration: SwiftMessages.Duration = .automatic) {
        DispatchQueue.main.async {
            let view = MessageView.viewFromNib(layout: .cardView)
            
            // Theme message elements with the warning style.
            view.configureTheme(type)
            
            // Add a drop shadow.
            view.configureDropShadow()
            
            // Set message title, body, and icon. Here, we're overriding the default warning
            // image with an emoji character.
            view.button?.isHidden = true
            view.configureContent(title: type.title , body: /text, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "OK") { (button) in
                SwiftMessages.hide()
            }
            
            var config = SwiftMessages.defaultConfig
            
            config.presentationStyle = .top
            
            config.presentationContext = .window(windowLevel: UIWindow.Level.normal)//UIWindowLevelStatusBar)
            
            // Disable the default auto-hiding behavior.
            config.duration = .automatic
            
            // Dim the background like a popover view. Hide when the background is tapped.
            config.dimMode = .gray(interactive: true)
            
            // Disable the interactive pan-to-hide gesture.
            config.interactiveHide = true
            
            // Specify a status bar style to if the message is displayed directly under the status bar.
            config.preferredStatusBarStyle = .lightContent
            
            // Show message with default config.
            //SwiftMessages.show(view: view)
            
            // Customize config using the default as a base.
            config.duration = duration
            
            // Show the message.
            SwiftMessages.show(config: config, view: view)
        }
    }
    
    class func appendOptionalStrings(withArray array : [String?]) -> String {
        return array.compactMap{$0}.joined(separator: " ")
    }
    
    
    class func show(nativeActionSheet title : String? , subTitle : String? , vc : UIViewController? , senders : [Any] , success : @escaping (Any,Int) -> ()){
        
        let alertController =  UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        for (index,element) in senders.enumerated() {
            alertController.addAction(UIAlertAction(title: element as? String ?? "", style: UIAlertAction.Style.default , handler: { (action) in
                success(element, index)
            }))
            
            
        }
        alertController.addAction(UIAlertAction(title: "Cancel" , style: UIAlertAction.Style.cancel, handler: nil))
        vc?.present(alertController, animated: true, completion: nil)
        
    }
    
    class func showAlertCustom(nativeActionSheet title : String? , subTitle : String? , vc : UIViewController? , senders : [Any] , success : @escaping (Any,Int) -> ()){
        
        let alertController =  UIAlertController(title: title, message: subTitle, preferredStyle: UIAlertController.Style.actionSheet)
        
        for (index,element) in senders.enumerated() {
            alertController.addAction(UIAlertAction(title: element as? String ?? "", style: UIAlertAction.Style.default , handler: { (action) in
                success(element, index)
            }))
            
            
        }
        alertController.addAction(UIAlertAction(title: "Cancel" , style: UIAlertAction.Style.cancel, handler: nil))
        vc?.present(alertController, animated: true, completion: nil)
              
    }
    
    class func show(alert title:String , message:String  , buttonOk: @escaping () -> () , viewController: UIViewController , buttonText: String ){
        
        let alertController = UIAlertController(title: title, message: message , preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Cancel" , style: UIAlertAction.Style.cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: buttonText , style: UIAlertAction.Style.default, handler: {  (action) in
            buttonOk()
        }))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    class func show(alert title:String , message:String  , buttonOk: @escaping () -> () , viewController: UIViewController , buttonText: String , buttonCancel: @escaping () -> ()  ){
        
        let alertController = UIAlertController(title: title, message: message , preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Cancel" , style: UIAlertAction.Style.cancel, handler: {  (action) in
            buttonCancel()
        }))
        alertController.addAction(UIAlertAction(title: buttonText , style: UIAlertAction.Style.destructive, handler: {  (action) in
            buttonOk()
        }))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlertMessage(alert title:String , message:String  , viewController: UIViewController , buttonText: String,  buttonOk: @escaping () -> () ) {
        
        let alertController = UIAlertController(title: title,    message: message , preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title:buttonText , style: UIAlertAction.Style.default, handler: {  (action) in
            buttonOk()
        }))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlertMessage(alert title:String , message:String  , viewController: UIViewController , buttonText: String ){
        
        let alertController = UIAlertController(title: title,    message: message , preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title:buttonText , style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    class func isCameraPermission() -> Bool {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        switch cameraAuthorizationStatus {
        case .authorized: return true
        case .restricted: return false
        case .denied:return false
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                debugPrint(granted)
            })
            return true
        }
    }
    
    class func accessToPhotos()-> Bool{
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized: return true
        case .restricted: return false
        case .denied: return false
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    
                } else {
                    
                }
                debugPrint(newStatus)
            })
            return true
        }
    }
    
//    class func isLocationEnable() -> Bool {
//        if CLLocationManager.locationServicesEnabled() {
//            switch(CLLocationManager.authorizationStatus()) {
//            case .restricted, .denied:
//                 UtilityFunctions.showAlertMessage(alert: "", message: "You have to enable location service else we are not able to show you your nearby maids", viewController: /UIApplication.getTopMostViewController(), buttonText: StaticStrings.ok.rawValue)
//                debugPrint("No access")
//                return false
//            case .notDetermined:
//                UtilityFunctions.showAlertMessage(alert: "", message: "Please enable location service else we are not able to show you your nearby maids", viewController: /UIApplication.getTopMostViewController(), buttonText: StaticStrings.ok.rawValue)
//                 UtilityFunctions.showAlertMessage(alert: "", message: "You have to enable location service else we are not able to show you your nearby maids", viewController: /Application.rootViewController, buttonText: StaticStrings.ok.rawValue)
//                debugPrint("No access")
//                return false
//            case .notDetermined:
//                UtilityFunctions.showAlertMessage(alert: "", message: "Please enable location service else we are not able to show you your nearby maids", viewController: /Application.rootViewController, buttonText: StaticStrings.ok.rawValue)
//                return true
//            case .authorizedAlways, .authorizedWhenInUse:
//                return true
//            }
//        } else {
//            
//            UtilityFunctions.showAlertMessage(alert: "", message: "You have to enable location service else we are not able to show you your nearby maids", viewController: /UIApplication.getTopMostViewController(), buttonText: StaticStrings.ok.rawValue)
//
//            return false
//        }
//    }
    
    class func accessToAudio()->Bool{
        let microPhoneStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        
        switch microPhoneStatus {
        case .authorized:
            return true
        case .denied:
            return false
        case .restricted:
            return false
        case .notDetermined:
            return true
        }
    }
    
    enum Position{
        case top
        case bottom
    }
    
    public static func runThisInMainThread(_ block: @escaping ()->()) {
        DispatchQueue.main.async(execute: block)
    }
    
    
    func startAnimate(message: String?){
        
        /*(/UIApplication.getTopMostViewController()).sta startAnimating(CGSize(width: 40 , height: 40 ), message: message, messageFont: nil, type: .ballClipRotate, color: Hex.lightOrange.toUIColor()  , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil) */
    }
    
    func startAnimate(){
        
       /* startAnimating(CGSize(width: 40 , height: 40 ), message: nil, messageFont: nil, type: .ballClipRotate, color: Hex.lightOrange.toUIColor()  , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil) */
    }
    
    func stopAnimate(){
        
       /* self.stopAnimating() */
    }
}

