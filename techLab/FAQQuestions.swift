//
//  FAQQuestions.swift
//  techLab
//
//  Created by Neel Khattri on 6/23/17.
//  Copyright © 2017 SimpleStuff. All rights reserved.
//

import Foundation

class FAQ {
    private var _title: String!
    private var _message: String!
    private var _time: String!
    private var _questionKey: String!
    private var _name: String!
    
    var name: String {
        return _name
    }
    var title: String {
        return _title
    }
    var message: String {
        return _message
    }
    var time: String {
        return _time
    }
    var questionKey: String {
        return _questionKey
    }
    
    init (dictionary: Dictionary<String, AnyObject>, questionKey: String) {
        _questionKey = questionKey
        if let time = dictionary["time"] as? String {
            self._time = time
        }
        if let name = dictionary["name"] as? String {
            self._name = name
        }
        if let message = dictionary["message"] as? String {
            self._message = message
        }
        if let title = dictionary["title"] as? String {
            self._title = title
        }
    }
}
