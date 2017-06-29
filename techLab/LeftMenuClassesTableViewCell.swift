//
//  LeftMenuClassesTableViewCell.swift
//  techLab
//
//  Created by Neel Khattri on 6/11/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import UIKit

class LeftMenuClassesTableViewCell: UITableViewCell {

    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell (classNameValue: String) {
        classImage.image = UIImage(named: classNameValue)
        className.text = classNameValue
    }

}
