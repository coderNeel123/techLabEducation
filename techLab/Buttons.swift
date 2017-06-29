//
//  Buttons.swift
//  techLab
//
//  Created by Neel Khattri on 6/10/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import Foundation
import UIKit

private var _materialKey = false
extension UIButton {
    @IBInspectable var materialDesign: Bool {
        get {
            return _materialKey
        } set {
            _materialKey = newValue
            if _materialKey == true {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = self.frame.height * 0.5
            }
            else {
                self.layer.cornerRadius = self.frame.height * 0.15
            }
        }
    }
}
