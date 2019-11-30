//
//  QuestionsTableViewCell.swift
//  Aceros
//
//  Created by Apple on 27/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import IBAnimatable

protocol QuestionsTableViewCellDelegate {
    func updateAnswerObject(indx:Int,answer:String?)
}


class QuestionsTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var lblQuesName: UILabel!
    @IBOutlet weak var tvAnswer: AnimatableTextView!
    var delegate:QuestionsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.updateAnswerObject(indx: textView.tag, answer: textView.text)
    }
    
}
