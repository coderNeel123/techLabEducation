//
//  Classes.swift
//  techLab
//
//  Created by Neel Khattri on 6/11/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import Foundation

class Classes {
    private var _className = [String]()
    
    var className: [String] {
        return _className
    }
    
    init (dictionary: Dictionary<String, AnyObject>) {
        if dictionary["Java"] as? Bool == true {
            _className.append("Java")
        }
        if dictionary["Arduino"] as? Bool == true {
            _className.append("Arduino")
        }
        if dictionary["iOS"] as? Bool == true {
            _className.append("iOS")
        }
        if dictionary["Python"] as? Bool == true {
            _className.append("Python")
        }
        if dictionary["Web"] as? Bool == true {
            _className.append("Web")
        }
    }
}
