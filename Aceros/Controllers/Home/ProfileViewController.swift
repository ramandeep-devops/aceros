//
//  ProfileViewController.swift
//  Aceros
//
//  Created by Apple on 18/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import IBAnimatable

protocol ProfileViewControllerDelegate {
    func updateHomeScreen(isDayOut :Bool, isProfileUpdated:Bool)
}

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imgUserImage: UIButton!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblPhoneNumber: UITextField!
    @IBOutlet weak var lblAddress: UITextView!
    @IBOutlet weak var lblManagerName: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var btnDayOut: AnimatableButton!
    
    var delegate:ProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSetup()
    }
    
    func viewSetup(){
        
        let data = Singleton.shared.userData?.profile
        tfName.text = data?.fullname
        lblPhoneNumber.text = data?.phone
        lblManagerName.text = data?.manager_fullname
        if data?.address != ""{
         lblAddress.text = data?.address
        }
        else{ lblAddress.text = R.string.localizable.profileNotAvailable()}
        
        lblType.text = data?.user_role?.toString
        
        tfName.isEnabled = false
        lblPhoneNumber.isEnabled = false
        lblManagerName.isEnabled = false
        lblType.isEnabled = false
        lblAddress.isEditable = false
        imgUserImage.isUserInteractionEnabled = false
        btnDayOut.isUserInteractionEnabled = true
        
        if (/data?.is_day_out?.boolValue){
            btnDayOut.alpha = 0.5
            btnDayOut.isUserInteractionEnabled = false
        }
        
        if (!(/data?.is_day_out?.boolValue) && !(/data?.is_day_in?.boolValue)){
            btnDayOut.isHidden = true
        }
       
        
        if let val = Singleton.shared.userData?.profile?.image, val != ""{
            let userImage =  APIConstants.imageBasePath + val
              self.imgUserImage.kf.setImage(with: URL.init(string: userImage), for: .normal, placeholder: R.image.user(), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
    }
    
    
    func pickImage(){
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
        AttachmentHandler.shared.imagePickedBlock = { [weak self] item in
//            self?.imgUserImage.setBackgroundImage(item, for: .normal)
            self?.imgUserImage.setImage(item, for: .normal)

        }
    }
    
    // MARK: - Button Action
    
    @IBAction func actionChangeProfilePic(_ sender: Any) {
        self.pickImage()
    }
    
    @IBAction func actionDismissController(_ sender: Any) {
        UIApplication.topViewController()?.dismiss(animated: true)
    }
    
    
    @IBAction func actionEdit(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            sender.backgroundColor = AppColor.themeColor.getColor()
            sender.setTitle("Save", for: .selected)
            tfName.isEnabled = true
            lblAddress.isEditable = true
            imgUserImage.isUserInteractionEnabled = true
            
            tfName.becomeFirstResponder()
        }
        else{
            
            if tfName.text == "" || lblAddress.text == ""{
                UtilityFunctions.makeToast(text: R.string.localizable.popFieldsNecessary(), type: .error)
                return
            }
            
            sender.backgroundColor = UIColor.white
            sender.setTitle("Edit", for: .normal)
            tfName.isEnabled = false
            lblAddress.isEditable = false
            
            
            
            self.updateProfile()
        }
    }
    
    @IBAction func actionDayOut(_ sender: Any) {
        
        
        let dayOutResponse:ResultCallback<User?,ResponseStatus>  = { result in
            switch result {
            case .success(let data):
                guard let _ = data else { return }
                
                if (/data?.success).boolValue{
                    self.delegate?.updateHomeScreen(isDayOut: true, isProfileUpdated: false)
                    UtilityFunctions.makeToast(text:R.string.localizable.popDayOutSucceess(), type: .success)
                    UIApplication.getTopMostViewController()?.dismiss(animated: true)
                }
                else{
                    UtilityFunctions.makeToast(text: /data?.msg, type: .error)
                }
            case .failure(let error):
                UtilityFunctions.makeToast(text: error.localizedDescription, type: .error)
                return
            }
        }
        
        HomeTarget.userDayOut(access_token: /Singleton.shared.userData?.profile?.access_token).requestCodable(showLoader: true, response: dayOutResponse)
    }
    
    func updateProfile(){
        
        if let image = self.imgUserImage.image(for: .normal){
            
            let updatedResponse:ResultCallback<User?,ResponseStatus>  = { result in
                switch result {
                case .success(let data):
                    guard let _ = data else { return }
                    
                    if (/data?.success).boolValue{
                        self.delegate?.updateHomeScreen(isDayOut: true, isProfileUpdated: false)
                        UtilityFunctions.makeToast(text: R.string.localizable.popProfileUpdateSuccess(), type: .success)
                    }
                    else{
                        UtilityFunctions.makeToast(text: /data?.msg, type: .error)
                    }
                case .failure(let error):
                    UtilityFunctions.makeToast(text: error.localizedDescription, type: .error)
                    return
                }
            }
            
            HomeTarget.updateProfile(fullName: /tfName.text, address: /lblAddress.text, image:  image).requestCodable(showLoader: true, response: updatedResponse)
            
        }
        
    }
    
    
}
