//
//  BuildingClientsTableViewCell.swift
//  Aceros
//
//  Created by Apple on 18/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

protocol BuildingClientsTableViewCellDelegate {
    func reloadRowAtIndex(index:Int)
}

class BuildingClientsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    
    
    var delegate:BuildingClientsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func actionMore(_ sender: UIButton) {
        lblDesc.numberOfLines = 0
        delegate?.reloadRowAtIndex(index: sender.tag)
    }
    
}
