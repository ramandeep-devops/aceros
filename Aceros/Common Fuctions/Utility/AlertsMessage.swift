////
////  Alerts.swift
////  Grintafy
////
////  Created by Sierra 4 on 14/07/17.
////  Copyright © 2017 com.example. All rights reserved.
////
//
//import UIKit
//import ISMessages
//
//class AlertsMessages: NSObject {
//    
//    static let shared = AlertsMessages()
//    
//    //MARK: - Show ISMessages Alert
//    func show(alert title : Alert , message : String , type : ISAlertType){
//        
//        ISMessages.showCardAlert(withTitle: title.rawValue, message: message, duration: 3.0, hideOnSwipe: true, hideOnTap: true, alertType: type, alertPosition: .bottom, didHide: nil)
//        
//        
//        
//    }
//    
//    func show(alert title : String , message : String , type : ISAlertType){
//        
//        ISMessages.showCardAlert(withTitle: title , message: message, duration: 3.0, hideOnSwipe: true, hideOnTap: true, alertType: type, alertPosition: .bottom, didHide: nil)
//    }
//    
//    func showOnTop(alert title : String , message : String , type : ISAlertType){
//        
//        ISMessages.showCardAlert(withTitle: title , message: message, duration: 3.0, hideOnSwipe: true, hideOnTap: true, alertType: type, alertPosition: .top, didHide: nil)
//    }
//    
//}
