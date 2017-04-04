//
//  LocationService.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 3/31/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit
import CoreLocation
import XCGLogger
import PromiseKit


class LocationService {
    let locationRepository = LocationRepository()
    
    func add(_ location: Location) -> Promise<Bool> {
        return locationRepository.add(location)
    }
    
    func add(_ location: CLLocation) -> Promise<Bool> {
        let loc = Location(
            id: UUID().uuidString,
            lat: location.coordinate.latitude,
            lng: location.coordinate.longitude,
            createdTime: Date(),
            arrivalTime: nil,
            departureTime: nil,
            transport: nil,
            type: .route)
        return locationRepository.add(loc)
    }
    
    func all(_ date: Date? = nil) -> Promise<[Location]> {
        return locationRepository.all(date)
    }
    
    func deleteAll() -> Promise<Bool> {
        return locationRepository.deleteAll()
    }
}

//class LocationService: NSObject {
//    
//    var locationManager: CLLocationManager!
//    let locationRepository = LocationRepository()
//    
//    func startStandardUpdates() {
//        if locationManager == nil {
//            locationManager = CLLocationManager()
//        }
//        
//        locationManager.requestAlwaysAuthorization()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        
//        locationManager.distanceFilter = 10
//        locationManager.startUpdatingLocation()
//    }
//    
//    func startMonitoringVisits() {
//        
//    }
//    
//    func stop​Monitoring​Visits() {
//        
//    }
//}
//
//extension LocationService: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            let eventDate = location.timestamp
//            let howRecent = eventDate.timeIntervalSinceNow
//            if abs(howRecent) < 15.0 {
//                log.debug(location.description)
//                
//                let loc = Location(
//                    id: UUID().uuidString,
//                    lat: location.coordinate.latitude,
//                    lng: location.coordinate.longitude,
//                    createdTime: Date(),
//                    arrivalTime: nil,
//                    departureTime: nil,
//                    transport: nil)
//                locationRepository.add(loc)
//            }
//        }
//    }
//}
