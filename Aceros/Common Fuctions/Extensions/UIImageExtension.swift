//
//  UIImage+Extension.swift
//  Motor_Nation
//
//  Created by Sierra 4 on 25/07/17.
//  Copyright © 2017 code-brew. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImage {
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0.1
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.95
        case highest = 1
    }
    
    var png: Data? { return self.pngData() }
    
    func reduceSize(_ quality: JPEGQuality) -> UIImage {
        
        switch quality {
        case .low, .lowest:
            return self.kf.image(withRoundRadius: 0.0, fit: CGSize(width: 100.0, height: 100.0))
        default :
            return self.kf.image(withRoundRadius: 0.0, fit: CGSize(width: 200.0, height: 200.0))
        }
    }
    
    func resize(with width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImage().jpegData(compressionQuality: quality.rawValue)
    }
    
    func sizeOfImage() -> Int? {
        
        let data = UIImage().jpegData(compressionQuality: 1)
        return  /data?.count
    }
}





