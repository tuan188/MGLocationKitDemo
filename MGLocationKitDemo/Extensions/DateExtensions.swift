//
//  DateExtensions.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 3/31/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit

struct Formatter {
}

extension Date {
    var date: Date {
        let cal = Calendar(identifier: .gregorian)
        return cal.startOfDay(for: self)
    }
    
    var tomorrow: Date {
        let cal = Calendar(identifier: .gregorian)
        return cal.date(byAdding: .day, value: 1, to: self)!
    }
    
    func fullDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
}
