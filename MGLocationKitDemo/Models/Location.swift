//
//  Location.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 3/31/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit
import CoreLocation

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
    
    var location: CLLocation {
        return CLLocation(latitude: self.lat, longitude: self.lng)
    }
    
    var description: String {
        return [ type.description, createdTime.timeString, String(accuracy), String(speed)].joined(separator: " ")
    }
    
    func distance(from location: Location) -> Double {
        let coordinate1 = CLLocation(latitude: self.lat, longitude: self.lng)
        let coordinate2 = CLLocation(latitude: location.lat, longitude: location.lng)
        return coordinate1.distance(from: coordinate2)
    }
    
    func duration(from location: Location) -> Double {
        return abs(self.createdTime.timeIntervalSince(location.createdTime))
    }
}

enum LocationClusterType {
    case type1
    case type2
    case type3
}

class LocationCluster {
    var locations: [Location]
    var type: LocationClusterType
    
    var numberOfLocations: Int {
        return locations.count
    }
    
    var description: String {
        return [
            "A: " + (self.arrivalTime?.timeString ?? ""),
            "D: " + (self.departureTime?.timeString ?? ""),
            "C: " + String(numberOfLocations)
        ].joined(separator: "; ")
//        return ["Count = " + String(numberOfLocations), "Time = " + String(duration)].joined(separator: "; ")
    }
    
    var centroid: CLLocation {
        if locations.count == 0 {
            return CLLocation()
        } else if locations.count == 1 {
            return locations[0].location
        }
        let centroidLat = locations.reduce(0, { (result, location) -> Double in
            return result + location.lat
        })
        let centroidLng = locations.reduce(0, { (result, location) -> Double in
            return result + location.lng
        })
        return CLLocation(latitude: centroidLat/Double(locations.count), longitude: centroidLng/Double(locations.count))
    }
    
    var centerLocation: Location {
        var index = 0
        let center = self.centroid
        
        for i in 1..<locations.count {
            if locations[i].location.distance(from: center) < locations[index].location.distance(from: center) {
                index = i
            }
        }
        return locations[index]
    }
    
    var duration: TimeInterval {
        guard locations.count >= 2 else {
            return 0.0
        }
        var duration = 0.0
        for i in 1..<locations.count {
            duration += locations[i].duration(from: locations[i-1])
        }
        return duration
    }
    
    var arrivalTime: Date? {
        return locations.min { $0.createdTime < $1.createdTime }?.createdTime
    }
    
    var departureTime: Date? {
        return locations.max { $0.createdTime < $1.createdTime }?.createdTime
    }
    
    init() {
        locations = [Location]()
        type = LocationClusterType.type1
    }
    
    init(locations: [Location]) {
        self.locations = locations
        type = LocationClusterType.type1
    }
    
    func add(_ location: Location) {
        locations.append(location)
    }
    
    func add(_ locations: [Location]) {
        self.locations.append(contentsOf: locations)
    }
    
    func distance(from location: Location) -> Double {
        switch self.numberOfLocations {
        case 0:
            return 0
        case 1:
            return self.locations[0].distance(from: location)
        default:
            return self.centroid.distance(from: location.location)
        }
    }
    
    func distance(from cluster: LocationCluster) -> Double {
        guard self.numberOfLocations > 0 && cluster.numberOfLocations > 0 else {
            return 0.0
        }
        
        return self.centroid.distance(from: cluster.centroid)
    }
    
    func duration(from cluster: LocationCluster) -> Double {
        guard let departure1 = cluster.departureTime,
            let arrival2 = self.arrivalTime,
            departure1 < arrival2 else {
            return 0
        }
        return arrival2.timeIntervalSince(departure1)
    }
    
    func merge(_ cluster: LocationCluster) {
        locations.append(contentsOf: cluster.locations)
    }
}
