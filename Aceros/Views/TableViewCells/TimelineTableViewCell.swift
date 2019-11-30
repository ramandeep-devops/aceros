//
//  TimelineTableViewCell.swift
//  Aceros
//
//  Created by Apple on 16/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import IBAnimatable
protocol TimelineCellDelegate:AnyObject{
    func actionCheckInOrDetail(isCheckIn: Bool, indexPath: Int)
}

class TimelineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCheckIn: AnimatableButton!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var heightBtnDetail: NSLayoutConstraint!
    @IBOutlet weak var viewSeparator: UIView!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    
    var delegate:TimelineCellDelegate?
    
    var isHistory = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func actionCheckInViewDetail(_ sender: UIButton) {
        if sender.tag == 0 && !isHistory{
            delegate?.actionCheckInOrDetail(isCheckIn: true, indexPath: sender.tag)
        }
        else{
            delegate?.actionCheckInOrDetail(isCheckIn: false, indexPath: sender.tag)
        }
    }
}
