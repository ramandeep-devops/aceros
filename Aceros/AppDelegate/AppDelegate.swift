//
//  AppDelegate.swift
//  Aceros
//
//  Created by Apple on 15/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import IQKeyboardManagerSwift
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
                GMSServices.provideAPIKey(APIConstants.googleApiKey)
                GMSPlacesClient.provideAPIKey("AIzaSyBiBi-y-jreGQjQfu1M1Fnr8WYZxIZIrxw")
        
//        GMSServices.provideAPIKey("AIzaSyBiBi-y-jreGQjQfu1M1FnrZIrxw")
//        GMSPlacesClient.provideAPIKey("AIzaSyBiBi-y-jreGQjQfu1M1FnrZIrxw")
        
        IQKeyboardManager.shared.enable = true
        //        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarTintColor = AppColor.themeColor.getColor()
        UIApplication.shared.registerForRemoteNotifications()
        if Singleton.shared.userData != nil{ navigateToHome()}
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        NotificationCenter.default.post(name: Notification.Name(notificationIdentifier.ApplicationDidBecomeActive.rawValue), object: nil)
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


extension AppDelegate {
    
    //MARK: - Navigate To Home (If user logged in)
    func navigateToHome() {
        guard let vc = R.storyboard.main.homeMapViewController(), let window = window else { return }
        
        let navigationControl = window.rootViewController as? UINavigationController
        navigationControl?.viewControllers = []
        
        let homeNavigationController = UINavigationController(rootViewController: vc)
        homeNavigationController.isNavigationBarHidden = true
        
        UIView.transition(with: window, duration: 0.0, options: .allowAnimatedContent, animations: { [weak self] in
            self?.window?.rootViewController = homeNavigationController
            }, completion: nil)
    }
    
}
