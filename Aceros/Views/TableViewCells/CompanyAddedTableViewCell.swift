//
//  CompanyAddedTableViewCell.swift
//  Aceros
//
//  Created by Apple on 24/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class CompanyAddedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var clientEmail: UILabel!
    @IBOutlet weak var clientPhone: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
