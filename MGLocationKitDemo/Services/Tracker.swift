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
        manager.distanceFilter = 1
        
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    weak var delegate: TrackerDelegate?
    
    let regionIdentifier = "regionIdentifier"
    var region: CLRegion?
    
    func startMonitoringSignificantLocationChanges() {
        significantLocationManager.startMonitoringSignificantLocationChanges()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        
    }
    
    func startMonitoring(for location: CLLocation) {
        if let region = self.region {
            regionLocationManager.stopMonitoring(for: region)
        }
        else {
            for region in regionLocationManager.monitoredRegions {
                regionLocationManager.stopMonitoring(for: region)
            }
        }
        
        let identifier = "region-" + Date().timeString
        
        region = CLCircularRegion(center: location,
                                      radius: 80,
                                      identifier: identifier)
        regionLocationManager.startMonitoring(for: region!)
        
        // request state
//        regionLocationManager.requestState(for: region)
        
    }
    
    func start() {
        self.startMonitoringSignificantLocationChanges()
        self.startUpdatingLocation()
    }
    
}

extension Tracker: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    // region
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        event.add(content: "Enter region " + region.identifier)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        event.add(content: "Exit region " + region.identifier)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        event.add(content: "Determine state " + region.identifier)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        
    }
    
}
