//
//  RightMenuTableViewCell.swift
//  techLab
//
//  Created by Neel Khattri on 6/12/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import UIKit

class RightMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var settingsImage: UIImageView!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var settingsName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func notificationsSwitchTapped(_ sender: Any) {
        
    }
}
