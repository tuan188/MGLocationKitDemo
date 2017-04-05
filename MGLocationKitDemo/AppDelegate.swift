//
//  AppDelegate.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 3/31/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit
import MagicalRecord
import XCGLogger
import CoreLocation

let log = XCGLogger.default
let event = EventService.sharedInstance

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var locationManager = TrackingLocationManager()
    var backgroundLocationManager = BackgroundLocationManager()
    
    let locationService = LocationService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        MagicalRecord.setupAutoMigratingCoreDataStack()
        MagicalRecord.setLoggingLevel(MagicalRecordLoggingLevel.error)
        
        
        log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: logFileURL(), fileLevel: .debug)
        log.logAppDetails()
        
        if launchOptions?[UIApplicationLaunchOptionsKey.location] != nil {
            event.add(content: "UIApplicationLaunchOptionsLocationKey: startMonitoringLocationInBackground")
            
            startMonitoringLocationInBackground()
        }
        else {
            startTracking()
        }
        
        return true
    }
    
    func startMonitoringLocationInBackground() {
        backgroundLocationManager.startBackground() { result in
            if case let .Success(location) = result {
                self.locationService.add(location).catch {_ in }
                event.add(content: location.description)
            }
        }
    }
    
    func startTracking() {
        backgroundLocationManager.start() { [unowned self] result in
            if case let .Success(location) = result {
                self.updateBackgroundLocation(location: location)
            }
        }
        
        locationManager.start {[unowned self] result in
            if case let .Success(location) = result {
                self.updateLocation(location: location)
            }
        }
        
        locationManager.startMonitoringVisits { [weak self] (result) in
            if case let .Success(visit) = result {
                if visit.departureDate == Date.distantFuture {
                    let notifcation = "ARRIVED:  \(visit.coordinate.latitude) :: \(visit.coordinate.longitude) arrivalDate  \(visit.arrivalDate.fullDateString)"
                    self?.showNotification(notifcation)
                    let location = Location(
                        id: UUID().uuidString,
                        lat: visit.coordinate.latitude,
                        lng: visit.coordinate.longitude,
                        createdTime: visit.arrivalDate,
                        arrivalTime: visit.arrivalDate,
                        departureTime: nil,
                        transport: nil,
                        type: .arrival,
                        accuracy: visit.horizontalAccuracy,
                        speed: 0)
                    self?.locationService.add(location)
                }
                else {
                    let notification = "LEFT: \(visit.coordinate.latitude) :: \(visit.coordinate.longitude) arrivalDate  \(visit.arrivalDate.fullDateString) departDate \(visit.departureDate.fullDateString)"
                    self?.showNotification(notification)
                    let location = Location(
                        id: UUID().uuidString,
                        lat: visit.coordinate.latitude,
                        lng: visit.coordinate.longitude,
                        createdTime: visit.departureDate,
                        arrivalTime: visit.arrivalDate == Date.distantPast ? nil : visit.arrivalDate,
                        departureTime: visit.departureDate,
                        transport: nil,
                        type: .departure,
                        accuracy: visit.horizontalAccuracy,
                        speed: 0)
                    self?.locationService.add(location)
                    
                }
            }
            self?.startMonitoringLocationInBackground()
        }
    }
    
    func showNotification(_ message : String)  {
        let localNotification = UILocalNotification()
        localNotification.alertBody =  message
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.fireDate = Date()
        UIApplication.shared.scheduleLocalNotification(localNotification)
        
    }
    
    private func updateBackgroundLocation(location: CLLocation) {
        self.locationService.add(location).catch { _ in }
        event.add(content: location.description)
        log.debug(location.description)
        
    }
    
    private func updateLocation(location: CLLocation) {
        self.locationService.add(location).catch { _ in }
        event.add(content: location.description)
        log.debug(location.description)
        
    }
    
    func logFileURL() -> URL {
        let cacheDirectoryUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last!
        return cacheDirectoryUrl.appendingPathComponent("log.txt")
    }
    
    static var sharedInstance = {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        MagicalRecord.cleanUp()
    }


}

