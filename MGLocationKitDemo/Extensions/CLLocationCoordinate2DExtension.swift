//
//  CLLocationCoordinate2DExtension.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 4/21/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit

extension CLLocationCoordinate2D {
    func distance(from location: CLLocation) -> Double {
        let loc = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return loc.distance(from: location)
    }
}
