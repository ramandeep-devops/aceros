//  //
//  //  Utility.swift
//  //  TicketManagement
//  //
//  //  Created by Aseem 13 on 12/04/17.
//  //  Copyright © 2017 Taran. All rights reserved.
//  //
//  
//  import UIKit
//  //import EZSwiftExtensions
//  import NVActivityIndicatorView
// 
//  class Utility: NSObject {
//    
//    static let shared = Utility()
//   
//    override init() {
//        super.init()
//
//    }
//    
//    //MARK:- Show Loader
//    func showLoader() {
//        
//        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//        
//        let activitydata = ActivityData(size: CGSize(width: 40, height: 40) , message: "", messageFont: UIFont.systemFont(ofSize: 16.0) , type: .ballClipRotate, color: Hex.mainGreen.toUIColor(), padding: 4.0, displayTimeThreshold: nil, minimumDisplayTime: nil)
//        
//        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activitydata, nil)
//    }
//    
//    
//    //MARK:- Hide Loader
//    func hideLoader(){
//        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
//    }
//    
//  }
