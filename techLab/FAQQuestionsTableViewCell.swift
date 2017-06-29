//
//  FAQQuestionsTableViewCell.swift
//  techLab
//
//  Created by Neel Khattri on 6/23/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import UIKit

class FAQQuestionsTableViewCell: UITableViewCell {

    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(questionObject: FAQ) {
        question.text = questionObject.message
        name.text = questionObject.name
        time.text = questionObject.time
        title.text = questionObject.title
    }
}
