//
//  AnswerQuestionsTableViewCell.swift
//  techLab
//
//  Created by Neel Khattri on 6/24/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import UIKit

class AnswerQuestionsTableViewCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var answer: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(answerObject: Comments) {
        time.text = answerObject.time
        name.text = answerObject.name
        answer.text = answerObject.comment
    }

}
