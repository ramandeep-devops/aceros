//
//  SearchTableViewCell.swift
//  Aceros
//
//  Created by Apple on 06/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
