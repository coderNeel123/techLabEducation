//
//  MainMessagesClass.swift
//  techLab
//
//  Created by Neel Khattri on 6/11/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import Foundation

class MainMessages {
    private var _name: String!
    private var _message: String!
    private var _time: String!
    private var _messageKey: String!
    
    var name: String {
        return _name
    }
    var message: String {
        return _message
    }
    var time: String {
        return _time
    }
    var messageKey: String {
        return _messageKey
    }
    
    init (name: String, message: String, time: String, messageKey: String) {
        _name = name
        _message = message
        _time = time
        _messageKey = messageKey
    }
    
    init (dictionary: Dictionary<String, AnyObject>, messagekey: String) {
        _messageKey = messagekey
        if let time = dictionary["time"] as? String {
            self._time = time
        }
        if let name = dictionary["name"] as? String {
            self._name = name
        }
        if let message = dictionary["message"] as? String {
            self._message = message
        }
    }
}
