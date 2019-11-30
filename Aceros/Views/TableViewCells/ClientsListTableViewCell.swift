//
//  ClientsListTableViewCell.swift
//  Aceros
//
//  Created by Apple on 25/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ClientsListTableViewCell: UITableViewCell {
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblInteractionStatus: UILabel!
    @IBOutlet weak var lblPlace: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
