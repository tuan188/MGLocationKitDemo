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
        
        let distanceThreshold = AppSettings.distanceThreshold
        let durationThreadhold = AppSettings.durationThreshold * 60
        
        var stopPoints = [LocationCluster]()
        var route = [Location]()
        var tempRoute = [Location]()
        var currentCluster = LocationCluster()
        
        func addToStopPoints(cluster: LocationCluster) -> Bool {
            if let lastSP = stopPoints.last, lastSP.distance(from: cluster) < distanceThreshold {
                lastSP.merge(cluster)
                return false
            }
            else {
                stopPoints.append(cluster)
                return true
            }
        }
        
        let firstLocation = locations[0]
        currentCluster.add(firstLocation)
        
        if firstLocation.type == .departure {
            currentCluster.type = .type1
            _ = addToStopPoints(cluster: currentCluster)
            
            currentCluster = LocationCluster()
            currentCluster.type = .type2
        }
        
        for i in 1..<locations.count {
            let location = locations[i]
            
            if currentCluster.distance(from: location) <= distanceThreshold {
                currentCluster.add(location)   // type 2
            }
            else if currentCluster.distance(from: location) > distanceThreshold && currentCluster.duration > durationThreadhold {
                
                if addToStopPoints(cluster: currentCluster) {
                    route.append(contentsOf: tempRoute)
                }
                tempRoute = []
                currentCluster = LocationCluster(locations: [location])
                currentCluster.type = .type2
            }
            else {
                tempRoute.append(contentsOf: currentCluster.locations)
                currentCluster = LocationCluster(locations: [location])
                currentCluster.type = .type2
                
                if location.type == .arrival || location.type == .departure {
                    if addToStopPoints(cluster: currentCluster) {
                        route.append(contentsOf: tempRoute)
                    }
                    tempRoute = []
                    
                    currentCluster = LocationCluster()
                    currentCluster.type = .type2
                }
            }
        }
        
        if currentCluster.numberOfLocations > 1  {
            if addToStopPoints(cluster: currentCluster) {
                route.append(contentsOf: tempRoute)
            }
        }
        else {
            route.append(contentsOf: currentCluster.locations)
            route.append(contentsOf: tempRoute)
        }
        
        let routeFromStopPoints = stopPoints.map { (cluster) -> Location in
            return cluster.centerLocation
        }
        
        route.append(contentsOf: routeFromStopPoints)
        route.sort{ $0.createdTime < $1.createdTime }
        
        return (stopPoints, route)
    }
    
}
