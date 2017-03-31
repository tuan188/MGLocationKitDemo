//
//  Location.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 3/31/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit

struct Location {
    let id: String
    let lat: Double
    let lng: Double
    let createdTime: Date
    let arrivalTime: Date?
    let departureTime: Date?
    let transport: String?
}
