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
            createdTime: location.timestamp,
            arrivalTime: nil,
            departureTime: nil,
            transport: nil,
            type: .route,
            accuracy: location.horizontalAccuracy,
            speed: location.speed)
        return locationRepository.add(loc)
    }
    
    func all(_ date: Date? = nil) -> Promise<[Location]> {
        return locationRepository.all(date)
    }
    
    func deleteAll() -> Promise<Bool> {
        return locationRepository.deleteAll()
    }
    
    func preprocessing(_ locations: [Location]) -> [Location] {
        guard locations.count > 0 else {
            return []
        }
        
        var result = [Location]()
        var previous = locations[0]
        result.append(previous)
        
        let velocityThreshold = 20.0 // m/s
        
        let horizontalAccuracy = AppSettings.horizontalAccuracy
        
        for i in 1..<locations.count {
            let location = locations[i]
            if location.type == .arrival || location.type == .departure {
                result.append(location)
                previous = location
                continue
            }
            if abs(location.accuracy) > horizontalAccuracy {
                continue
            }
            let velocity = location.distance(from: previous)/location.duration(from: previous)
            // TODO: threshold by transport
            if velocity > velocityThreshold {
                continue
            } else {
                result.append(location)
                previous = location
            }
        }
        
        return result
    }
    
    func extractStopPoints(_ locations: [Location]) -> (stopPoints: [LocationCluster], route: [Location]) {
        guard locations.count > 0 else {
            return ([], [])
        }
        
        var stopPoints = [LocationCluster]()
        var route = [Location]()
        var tempRoute = [Location]()
        
        var currentCluster = LocationCluster()
//        var previousCluster = currentCluster
        
        let distanceThreshold = AppSettings.distanceThreshold
        let durationThreadhold = AppSettings.durationThreshold * 60
        
        func addToStopPoints(cluster: LocationCluster) -> Bool {
            if let lastSP = stopPoints.last, lastSP.distance(from: cluster) < distanceThreshold {
                lastSP.merge(cluster)
//                previousCluster = lastSP // add
                return false
            }
            else {
                stopPoints.append(cluster)
//                previousCluster = cluster
                return true
            }
        }
        
//        func check() {
//            if currentCluster.duration(from: previousCluster) < durationThreadhold && currentCluster.distance(from: previousCluster) < distanceThreshold {
//                
//                previousCluster.merge(currentCluster)
//                
//                if previousCluster.type == .type2 {
//                    addToStopPoints(cluster: previousCluster)
//                }
//                else {
//                    previousCluster = currentCluster
//                }
//            }
//        }
        let firstLocation = locations[0]
        currentCluster.add(firstLocation)
        currentCluster.type = .type1
        
        if firstLocation.type == .departure {
            _ = addToStopPoints(cluster: currentCluster)
            currentCluster = LocationCluster()
            currentCluster.type = .type2
        }
        
        for i in 1..<locations.count {
            let location = locations[i]
//            let previousLocation = locations[i-1]
            
            if currentCluster.distance(from: location) <= distanceThreshold {
                currentCluster.add(location)
//                if currentCluster.type == .type1 {
//                    addToStopPoints(cluster: currentCluster)
//                    currentCluster = LocationCluster()
//                    currentCluster.type = .type2
//                }
            }
            else if currentCluster.distance(from: location) > distanceThreshold && currentCluster.duration > durationThreadhold {
                
                if addToStopPoints(cluster: currentCluster) {
                    route.append(contentsOf: tempRoute)
                }
                tempRoute = []
                currentCluster = LocationCluster(locations: [location])
                currentCluster.type = .type2
            }
            else if currentCluster.distance(from: location) > distanceThreshold && currentCluster.duration < durationThreadhold {
//                check()
                tempRoute.append(contentsOf: currentCluster.locations)
                currentCluster = LocationCluster(locations: [location])
                currentCluster.type = .type2
            }
//            else {
//                route.append(location)
//            }
//            else if location.distance(from: previousLocation) < distanceThreshold && location.duration(from: previousLocation) > durationThreadhold {
//                currentCluster = LocationCluster(locations: [previousLocation, location])
//                currentCluster.type = .type3
//                addToStopPoints(cluster: currentCluster)
//            }
//            else if location.distance(from: previousLocation) > distanceThreshold && location.duration(from: previousLocation) > durationThreadhold {
//                currentCluster = LocationCluster(locations: [location])
//                currentCluster.type = .type2
//            }
        }
        
        if currentCluster.numberOfLocations > 1 {
            _ = addToStopPoints(cluster: currentCluster)
        }
        else {
            route.append(contentsOf: currentCluster.locations)
        }
        
        route.append(contentsOf: tempRoute)
        
        let routeFromStopPoints = stopPoints.map { (cluster) -> Location in
            return cluster.centerLocation
        }
        route.append(contentsOf: routeFromStopPoints)
        route.sort{ $0.createdTime < $1.createdTime }
        
        return (stopPoints, route)
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
