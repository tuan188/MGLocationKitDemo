//
//  Tracker.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 4/19/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit
import CoreLocation

protocol TrackerDelegate: class {
    func trackerDidEnterRegion(center: CLLocation)
    func trackerDidExitRegion(center: CLLocationCoordinate2D)
}

class Tracker: NSObject {
    fileprivate lazy var significantLocationManager: CLLocationManager = {
        var manager: CLLocationManager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    fileprivate lazy var regionLocationManager: CLLocationManager = {
        var manager: CLLocationManager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    fileprivate lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        manager.distanceFilter = 1
        
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    weak var delegate: TrackerDelegate?
    
    let regionIdentifier = "regionIdentifier"
    var region: CLCircularRegion?
    
    let distanceThreshold = 50.0
    
    var trackingLocations = [CLLocation]()
    
    func startMonitoringSignificantLocationChanges() {
        significantLocationManager.startMonitoringSignificantLocationChanges()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func startMonitoring(for location: CLLocation) {
        if let region = self.region {
            let distance = region.center.distance(from: location)
            if distance > distanceThreshold {
                regionLocationManager.stopMonitoring(for: region)
            }
            else {
                return
            }
        }
        else {
            for region in regionLocationManager.monitoredRegions {
                regionLocationManager.stopMonitoring(for: region)
            }
        }
        
        let identifier = "region-" + Date().timeString
        
        region = CLCircularRegion(center: location.coordinate,
                                      radius: distanceThreshold,
                                      identifier: identifier)
        region?.notifyOnExit = true
        region?.notifyOnEntry = true
        regionLocationManager.startMonitoring(for: region!)
        
        event.add(content: "Start monitor region: " + region!.identifier)
        
        delegate?.trackerDidEnterRegion(center: location)
        
    }
    
    func start() {
        self.startMonitoringSignificantLocationChanges()
        self.startUpdatingLocation()
    }
    
}

extension Tracker: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard manager === locationManager else {
            return
        }
        guard let location = locations.max(by: { (location1, location2) -> Bool in
            return location1.timestamp.timeIntervalSince1970 < location2.timestamp.timeIntervalSince1970}) else { return }
        
        if trackingLocations.count >= 10 {
            let newLocation = trackingLocations.min { $0.horizontalAccuracy < $1.horizontalAccuracy }!
            trackingLocations = []
            
            stopUpdatingLocation()
            startMonitoring(for: newLocation)
            
            event.add(content: "Location " + newLocation.description)
        }
        else {
            trackingLocations.append(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    // region
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        event.add(content: "Enter region " + region.identifier)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard manager === regionLocationManager else {
            return
        }
        event.add(content: "Exit region " + region.identifier)
        if let circularRegion = region as? CLCircularRegion {
            delegate?.trackerDidExitRegion(center: circularRegion.center)
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        guard manager === regionLocationManager else {
            return
        }
        event.add(content: "Sate: \(state.rawValue) - " + region.identifier)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        guard manager === regionLocationManager else {
            return
        }
        event.add(content: "Monitor failed " + (region?.identifier ?? "null"))
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        guard manager === regionLocationManager else {
            return
        }
        event.add(content: "Monitor started " + region.identifier)
        regionLocationManager.requestState(for: region)
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        
    }
    
}
