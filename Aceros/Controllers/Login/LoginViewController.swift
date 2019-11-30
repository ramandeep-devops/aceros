//
//  LoginViewController.swift
//  Aceros
//
//  Created by Apple on 15/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var lblTermsAndConditions: UILabel!
    
    //MARK:- Variables
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    
    //MARK:- Custom Methods
    func viewSetup(){
        
        #if DEBUG
        tfEmail.text = "rohitsingh@code-brew.com"
        tfPassword.text = "123456"
        #else
        #endif
     
    }
    
    func navigateToHomeScreen(){
        guard let vcHome = R.storyboard.main.homeMapViewController() else{return}
        UIApplication.getTopMostViewController()?.pushVC(vcHome)
    }
    
    //MARK:- API Requests
    func loginUser(){
        
        let loginResponse:ResultCallback<User?,ResponseStatus>  = { result in
            switch result {
            case .success(let data):
                
                guard let user = data else { return }
                
                if (/data?.success).boolValue{
                    Singleton.shared.userData = user
                    
                    guard let delegate = UIApplication.shared.delegate as? AppDelegate, let window = delegate.window else{return}
                    let navigationControl = delegate.window?.rootViewController as? UINavigationController
                    navigationControl?.viewControllers = []
                    guard let vcHome = R.storyboard.main.homeMapViewController() else{return}
                    let homeNavigationController = UINavigationController(rootViewController: vcHome)
                    homeNavigationController.isNavigationBarHidden = true
                    UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: {
                        delegate.window?.rootViewController = homeNavigationController
                    }, completion: nil)
                }
                else{
                    UtilityFunctions.makeToast(text: /data?.msg, type: .error)
                }
            case .failure(let error):
                UtilityFunctions.makeToast(text: error.localizedDescription, type: .error)
            }
        }
        
        LoginTarget.login(username: /tfEmail.text, password: /tfPassword.text).requestCodable(showLoader: true, response: loginResponse)
    }
    
    //MARK:- Button Actions
    @IBAction func actionShowPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        tfPassword.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        
        if !(/tfEmail.text?.isEmpty) && !(/tfPassword.text?.isEmpty) {
            self.loginUser()
        }
        else{
            UtilityFunctions.makeToast(text: R.string.localizable.popNoUsernamePassword(), type: .error)
        }
        
    }
    
    @IBAction func actionForgotPassword(_ sender: Any) {
        guard let vc = R.storyboard.login.forgotViewController() else {
            return
        }
        UIApplication.getTopMostViewController()?.pushVC(vc)
    }
    
    @IBAction func actionTermsAndConditions(_ sender: Any) {
    }
    
}
