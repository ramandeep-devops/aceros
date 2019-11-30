//
//  BuildingIconView.swift
//  Aceros
//
//  Created by Apple on 18/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import IBAnimatable
class BuildingIconView: UIView {

    @IBOutlet weak var lblCount: AnimatableLabel!
    @IBOutlet weak var imgBuilding: UIImageView!
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "BuildingIconView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
    

}
