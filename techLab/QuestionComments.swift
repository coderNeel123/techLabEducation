//
//  QuestionComments.swift
//  techLab
//
//  Created by Neel Khattri on 6/26/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import Foundation

class Comments {
    private var _name: String!
    private var _time: String!
    private var _comment: String!
    
    var name: String {
        return _name
    }
    var time: String {
        return _time
    }
    var comment: String {
        return _comment
    }
    
    init(dictionary: Dictionary<String, AnyObject>, questionKey: String) {
        if let name = dictionary["name"]
        {
            _name = name as! String
        }
        if let time = dictionary["time"] {
            _time = time as! String
        }
        if let comment = dictionary["comment"] {
            _comment = comment as! String
        }
    }
}
