//
//  AddPhotosCollectionViewCell.swift
//  Aceros
//
//  Created by Apple on 17/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

protocol AddPhotosCollectionViewCellDelegate:AnyObject {
    func removePhoto(position:Int)
}

class AddPhotosCollectionViewCell: UICollectionViewCell {
    //MARK: - Outlets
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnRemove: UIButton!
    
    
    //MARK: - Variable
    var delegate :AddPhotosCollectionViewCellDelegate?
    
    
    @IBAction func actionBtnRemove(_ sender: UIButton) {
        delegate?.removePhoto(position: sender.tag)
    }
    
    
}
