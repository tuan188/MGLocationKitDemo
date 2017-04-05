//
//  Location.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 3/31/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit

enum LocationType: Int {
    case route = 0
    case arrival = 1
    case departure = 2
    
    var description: String {
        return String(describing: self)
    }
}

struct Location {
    let id: String
    let lat: Double
    let lng: Double
    let createdTime: Date
    let arrivalTime: Date?
    let departureTime: Date?
    let transport: String?
    let type: LocationType
    let accuracy: Double
    let speed: Double
    
    var description: String {
        return [ type.description, createdTime.timeString, String(accuracy), String(speed)].joined(separator: " ")
    }
}
