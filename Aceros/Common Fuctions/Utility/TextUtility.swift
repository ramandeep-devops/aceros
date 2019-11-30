////
////  TextUtility.swift
////  SideDrawer
////
////  Created by Apple on 15/11/18.
////  Copyright © 2018 Codebrew Labs. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Material
//
//private var __maxLengths = [UITextField: Int]()
//
//extension TextField {
//    @IBInspectable var maxLength: Int {
//        get {
//            guard let l = __maxLengths[self] else {
//                return 150 // (global default-limit. or just, Int.max)
//            }
//            return l
//        }
//        set {
//            __maxLengths[self] = newValue
//            addTarget(self, action: #selector(fix), for: .editingChanged)
//        }
//    }
//    @objc func fix(textField: UITextField) {
//        let t = textField.text
//        textField.text = t?.safelyLimitedTo(length: maxLength)
//    }
//}
//
//extension String
//{
//    func safelyLimitedTo(length n: Int)->String {
//        if (self.count <= n) {
//            return self
//        }
//        return String( Array(self).prefix(upTo: n) )
//    }
//}
//
//private var maxLengths = [JVFloatLabeledTextView: Int]()
//
//extension JVFloatLabeledTextView : UITextViewDelegate {
//    
//    @IBInspectable var maxLength: Int {
//        
//        get {
//            
//            guard let length = maxLengths[self]
//                else {
//                    return Int.max
//            }
//            return length
//        }
//        set {
//            maxLengths[self] = newValue
//            self.delegate = self
//        }
//    }
//    
//    @objc func limitLength(textView: UITextView) {
//        guard let prospectiveText = textView.text,
//            prospectiveText.count > maxLength
//            else {
//                return
//        }
//        
//        let selection = selectedTextRange
//        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
//        text = String(prospectiveText[..<maxCharIndex])
//        selectedTextRange = selection
//        
//    }
//    
//    public func textViewDidChange(_ textView: UITextView) {
//        limitLength(textView:textView)
//    }
//    
//    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        scrollToBottom()
//        return true
//    }
//    
//    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        scrollToBottom()
//        return true
//    }
//    
//    func scrollToBottom() {
//        let location = text.count - 1
//        let bottom = NSMakeRange(location, 1)
//        self.scrollRangeToVisible(bottom)
//    }
//    
//}
