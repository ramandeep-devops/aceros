
//
//  AddCompanyViewController.swift
//  Aceros
//
//  Created by Apple on 18/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit


protocol addCompanyVcDelegate {
    func addCompany(dic:[String:String])
}


class AddCompanyViewController: UIViewController {
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    var delegate :addCompanyVcDelegate?
    var address = ""
    var lati = ""
    var lng = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Button Action
    
    @IBAction func actionDismiss(_ sender: Any) {
        UIApplication.topViewController()?.dismiss(animated: true)
    }
    @IBAction func actionDone(_ sender: Any) {
        if tfName.hasText && tfPhoneNumber.hasText && /tfEmail.text?.isEmail{
            let dic = ["name" : /tfName.text, "mobile" : /tfPhoneNumber.text, "emails_id" : /tfEmail.text,"address":/address,"lati":/lati,"lng":/lng]
            delegate?.addCompany(dic: dic)
            UIApplication.topViewController()?.dismiss(animated: true)
        }
        else{
            if !(/tfEmail.text?.isEmail){
                UtilityFunctions.makeToast(text: "Please enter valid email address.", type: .error)
            }
            else{
                UtilityFunctions.makeToast(text: R.string.localizable.popFieldsNecessary(), type: .error)
            }
        }
    }

}
