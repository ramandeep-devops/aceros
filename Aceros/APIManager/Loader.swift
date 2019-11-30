//
//  Loader.swift
//  Electric_Scanner
//
//  Created by Paradox on 18/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

struct Loader {
    
    static var loaderFrame:CGRect {
        get {
            return CGRect(x: (UIScreen.main.bounds.width / 2) - 20, y: (UIScreen.main.bounds.height / 2) - 40, width: 30, height: 30)
        }
    }
    
    static var colour:UIColor {
        get {
            return AppColor.themeColor.getColor()
        }
    }
    
    static let loaderBackground:UIView = UIView(frame: UIScreen.main.bounds)
    static let loader = NVActivityIndicatorView(frame: loaderFrame, type: NVActivityIndicatorType.lineScalePulseOutRapid, color: colour, padding: nil)
    
}

extension UIViewController: NVActivityIndicatorViewable {
    
    //MARK: - Start Loader
    func startLoader() {
        DispatchQueue.main.async { [weak self] in
            let loaderView = Loader.loaderBackground
            let loader = Loader.loader
            loader.center = loaderView.center
            loaderView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            loaderView.addSubview(loader)
            self?.view.addSubview(loaderView)
            loader.startAnimating()
        }
        
    }
    
    //MARK: - Stop Loader
    func stopLoader() {
        DispatchQueue.main.async {
            Loader.loader.stopAnimating()
            Loader.loader.removeFromSuperview()
            Loader.loaderBackground.removeFromSuperview()
        }
    }
    
}


extension APIRequest {
    
    //MARK: - Show Loader
    func showLoader() {
        debugPrint("=======show loader======")
        UIApplication.getTopMostViewController()?.startLoader()
    }
    
    //MARK: - Hide Loader
    func hideLoader() {
        debugPrint("=======hide loader======")
        UIApplication.getTopMostViewController()?.stopLoader()
    }
    
}
