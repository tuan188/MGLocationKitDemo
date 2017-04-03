//
//  Event.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 4/3/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit

struct Event {
    let id: String
    let createdTime: Date
    let content: String
    
    init(content: String) {
        id = UUID().uuidString
        createdTime = Date()
        self.content = content
    }
    
    init(id: String, createdTime: Date, content: String) {
        self.id = id
        self.createdTime = createdTime
        self.content = content
    }
}
