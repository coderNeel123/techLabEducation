//
//  Users.swift
//  techLab
//
//  Created by Neel Khattri on 6/18/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import Foundation

class Users {
    private var _userName: String!
    var userName: String {
        return _userName
    }
    
    private var _userEmail: String!
    var userEmail: String {
        return _userEmail
    }
    
    init(dictionary: Dictionary<String, AnyObject>) {
        _userName = "\(dictionary["firstName"] as! String) \(dictionary["lastName"] as! String)"
        _userEmail = dictionary["email"] as! String
    }
}
