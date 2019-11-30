//
//  DocumentPickerBlock.swift
//  SideDrawer
//
//  Created by Apple on 30/08/18.
//  Copyright © 2018 Codebrew Labs. All rights reserved.
//

import Foundation
import MobileCoreServices
import UIKit

class DocumentPickerBlock :  NSObject ,  UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate {
    
    typealias onPicked = (URL) -> ()
    typealias onCanceled = () -> ()
    
    var pickedListner : onPicked?
    var canceledListner : onCanceled?
    var presentInVC : UIViewController?
    
    
    static let sharedInstance = DocumentPickerBlock()
    
    override init(){
        super.init()
        
    }
    
    deinit{
        
    }
    
    func pickerDocument( documentType : [String] , presentInVc : UIViewController , pickedListner : @escaping onPicked , canceledListner : @escaping onCanceled){
        
        self.pickedListner = pickedListner
        self.canceledListner = canceledListner
        self.presentInVC = presentInVc
        
        let importMenu = UIDocumentMenuViewController(documentTypes: documentType, in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.presentInVC?.present(importMenu, animated: true, completion: nil)
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        if let listener = pickedListner {
            
            let myURL = url as URL
            debugPrint("import result : \(myURL)")
            listener(myURL)
        }
      
    }
    
    
    func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.presentInVC?.present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        debugPrint("view was cancelled")
        controller.dismiss(animated: true, completion: nil)
        if let listener = canceledListner{
            listener()
        }
    }
    
    
}
