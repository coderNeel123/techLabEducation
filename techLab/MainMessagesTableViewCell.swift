//
//  MainMessagesTableViewCell.swift
//  techLab
//
//  Created by Neel Khattri on 6/11/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import UIKit

class MainMessagesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var time: UILabel!
    
    func customCell (messageObject: MainMessages) {
        if messageObject.name == firstNameConstant! + " " + lastNameConstant! {
            name.textColor = UIColor(red: 233/255, green: 0/255, blue: 76/255, alpha: 1)
        }
        else {
            name.textColor = UIColor(red: 0/255, green: 128/255, blue: 228/255, alpha: 1)
        }
        name.text = messageObject.name
        message.text = messageObject.message
        time.text = messageObject.time
    }

}
