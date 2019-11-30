////
////  LanguageFile.swift
////  Wade7Student
////
////  Created by OSX on 22/12/17.
////  Copyright © 2017 OSX. All rights reserved.
////
//
//import UIKit
////import EZSwiftExtensions
//internal struct Languages {
//
//    static let Arabic = "ar"
//    static let English = "en"
//    static let Urdu = "ur"
//    static let Chinese = "zh-Hans"
//}
//
//class LanguageFile: NSObject {
//
//    static let shared = LanguageFile()
//
//    //MARK: SetLanguage
//    func changeLanguage(type:String){
//
//        switch type {
//
//        case Languages.English:
//
//            UIView.appearance().semanticContentAttribute = .forceLeftToRight
//            BundleLocalization.sharedInstance().language = Languages.English
//            token.selectedLanguage = LanguageCode.English.get()
//            UserDefaults.standard.set(Languages.English, forKey: "language")
//
//
//        case Languages.Urdu:
//
//            BundleLocalization.sharedInstance().language = Languages.Urdu
//            UIView.appearance().semanticContentAttribute = .forceRightToLeft
//            token.selectedLanguage = LanguageCode.Urdu.get()
//            UserDefaults.standard.set(Languages.Urdu, forKey: "language")
//
//
//        case Languages.Arabic:
//
//            BundleLocalization.sharedInstance().language = Languages.Arabic
//            UIView.appearance().semanticContentAttribute = .forceRightToLeft
//            token.selectedLanguage = LanguageCode.Arabic.get()
//            UserDefaults.standard.set(Languages.Arabic, forKey: "language")
//
//        case Languages.Chinese:
//
//            UIView.appearance().semanticContentAttribute = .forceLeftToRight
//            BundleLocalization.sharedInstance().language = Languages.Chinese
//            token.selectedLanguage = LanguageCode.Chinese.get()
//            UserDefaults.standard.set(Languages.Chinese, forKey: "language")
//
//        default:
//
//            print("example")
//
//            UIView.appearance().semanticContentAttribute = .forceLeftToRight
//            BundleLocalization.sharedInstance().language = Languages.English
//            token.selectedLanguage = LanguageCode.English.get()
//            UserDefaults.standard.set(Languages.English, forKey: "language")
//        }
//
//        initializeStoryboard()
//    }
//
//    func initializeStoryboard(){
//
//        if  UserData.share.loggedInUser?._id != nil {
//            UIApplication.getTopMostViewController()?.popToRootVC()
//            let vc = R.storyboard.tabbar.tabBarController()
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = vc
//        }
//        else{
//            let vc = R.storyboard.authentication.loginViewController()
//            let nav = UINavigationController(rootViewController: vc!)
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = nav
//        }
//
//    }
//}
//
//extension UIView{
//
//    func setTextFields(mainView : [UIView]){
//
//        for view in mainView{
//            if view is UITextField {
//                let txtField = view as? UITextField
//                txtField?.textAlignment = setTexts()
//            }
//            else if view is UITextView {
//
//                let txtView = view as? UITextView
//                txtView?.textAlignment = setTexts()
//            }
//
//            else if view is UIButton{
//                if BundleLocalization.sharedInstance().language == Languages.Arabic || BundleLocalization.sharedInstance().language == Languages.Urdu{
//
//                    scaleButton(button: view as? UIButton)
//                }
//            }else{
//
//                setTextFields(mainView: view.subviews)}
//        }
//    }
//
//    func scaleButton(button : UIButton?){
//
//        if let widthTitle = button?.titleLabel?.frame.size.width, let widthImage = button?.imageView?.frame.size.width{
//            button?.titleEdgeInsets = UIEdgeInsets(top: 0, left: -widthTitle - 4, bottom: 0, right: -widthTitle)
//            button?.imageEdgeInsets = UIEdgeInsets(top: 0, left: -widthImage, bottom: 0, right: -widthImage - 4)
//
//        }
//    }
//
//    func setTexts() -> NSTextAlignment{
//        if BundleLocalization.sharedInstance().language == Languages.Arabic || BundleLocalization.sharedInstance().language == Languages.Urdu {
//            return .right
//        }else {return .left}
//    }
//
//    func setViewLeftAlign(mainView : [UIView]){
//
//        for view in mainView{
//            if view is UITextField {
//                let txtField = view as? UITextField
//                txtField?.textAlignment = .left
//            }
//            else if view is UITextView {
//
//                let txtView = view as? UITextView
//                txtView?.textAlignment = .left
//            }
//            else if view is UIButton{
//                let btn = view as? UIButton
//                btn?.setLeftAlign()
//            }else{
//                setViewLeftAlign(mainView: view.subviews)
//            }
//        }
//    }
//
//}
//
//extension UIButton{
//    func setAlignment() {
//        if BundleLocalization.sharedInstance().language == Languages.Arabic || BundleLocalization.sharedInstance().language == Languages.Urdu{
//            self.contentHorizontalAlignment = .right
//        }else {
//            self.contentHorizontalAlignment = .left
//        }
//    }
//
//    func setLeftAlign(){
//        self.contentHorizontalAlignment = .left
//    }
//
//    func setImageRotation(){
//
////        var imageRotated = UIImage(CGImage: self.imageView?.image?.CGImage, scale: 1.0, orientation: .DownMirrored)
//
//        if BundleLocalization.sharedInstance().language == Languages.Arabic || BundleLocalization.sharedInstance().language == Languages.Urdu{
//            self.setImage(self.imageView?.image?.withHorizontallyFlippedOrientation(), for: .normal)
//        }
//    }
//
//}
//
