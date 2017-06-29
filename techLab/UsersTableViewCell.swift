//
//  UsersTableViewCell.swift
//  techLab
//
//  Created by Neel Khattri on 6/18/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(userObject: Users) {
        name.text = userObject.userName
        email.text = userObject.userEmail
    }
}
