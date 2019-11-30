
//  MbKutz
//
//  Created by Aseem 13 on 15/12/16.
//  Copyright © 2016 Taran. All rights reserved.
//


import UIKit

class CameraGalleryPickerBlock: NSObject , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    typealias onPicked = (UIImage?) -> ()
    typealias onCanceled = () -> ()
    
    
    var pickedListner : onPicked?
    var canceledListner : onCanceled?
    
    static let sharedInstance = CameraGalleryPickerBlock()
    
    override init(){
        super.init()
        
    }
    
    deinit{
        
    }
    
    func pickerImage( type : String? , presentInVc : UIViewController , pickedListner : @escaping onPicked , canceledListner : @escaping onCanceled){
        
        self.pickedListner = pickedListner
        self.canceledListner = canceledListner
        
        let picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = /type == "Camera" ? UIImagePickerController.SourceType.camera : UIImagePickerController.SourceType.photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        presentInVc.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        if let listener = canceledListner{
            listener()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image =  info[UIImagePickerController.InfoKey.editedImage] as? UIImage,let listener = pickedListner else {return}
        listener(image)
    }
}
