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
    
    var fullDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: self)
    }
}
