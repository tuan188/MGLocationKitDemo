//
//  AppSettings.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 4/10/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit

class AppSettings: NSObject {
    
    class var didLoadDefaultValue: Bool {
        get {
            let defaults = UserDefaults.standard
            return defaults.bool(forKey: "didLoadDefaultValue")
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey:"didLoadDefaultValue")
            defaults.synchronize()
        }
    }
    
    class var distanceThreshold: Double {
        get {
            let defaults = UserDefaults.standard
            return defaults.double(forKey: "distanceThreshold")
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey:"distanceThreshold")
            defaults.synchronize()
        }
    }
    
    class var durationThreshold: Double {
        get {
            let defaults = UserDefaults.standard
            return defaults.double(forKey: "durationThreshold")
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey:"durationThreshold")
            defaults.synchronize()
        }
    }
    
    class var horizontalAccuracy: Double {
        get {
            let defaults = UserDefaults.standard
            return defaults.double(forKey: "horizontalAccuracy")
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey:"horizontalAccuracy")
            defaults.synchronize()
        }
    }
    
    class var showAnnotations: Bool {
        get {
            let defaults = UserDefaults.standard
            return defaults.bool(forKey: "showAnnotations")
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey:"showAnnotations")
            defaults.synchronize()
        }
    }
}
