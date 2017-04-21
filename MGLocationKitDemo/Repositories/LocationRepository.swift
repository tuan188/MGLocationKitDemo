//
//  LocationRepository.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 3/31/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit
import PromiseKit
import MagicalRecord

class LocationRepository {
    func add(_ location: Location) -> Promise<Bool> {
        return Promise { fulfill, reject in
            MagicalRecord.save({ (context) in
                if let entity = LocationEntity.mr_createEntity(in: context) {
                    EntityMapper.map(from: location, to: entity)
                }
            }) { (changed, error) in
                if let error = error {
                    reject(error)
                }
                else {
                    fulfill(changed)
                }
            }
        }
    }
    
    func all(_ date: Date? = nil) -> Promise<[Location]> {
        return Promise { fulfill, reject in
            let context = NSManagedObjectContext.mr_()
            var locations = [Location]()
            var entities: [LocationEntity]?
            if let date = date {
                let predicate = NSPredicate(format: "createdTime >= %@ && createdTime < %@", date.date as NSDate, date.tomorrow.date as NSDate)
                entities = LocationEntity.mr_findAllSorted(by: "createdTime", ascending: true, with: predicate, in: context) as? [LocationEntity]
            }
            else {
                entities = LocationEntity.mr_findAllSorted(by: "createdTime", ascending: true, in: context) as? [LocationEntity]
            }
            if let entities = entities  {
                for entity in entities {
                    locations.append(EntityMapper.location(from: entity))
                }
            }
            fulfill(locations)
        }
    }
    
    func deleteAll() -> Promise<Bool> {
        return Promise { fulfill, reject in
            MagicalRecord.save({ (context) in
                LocationEntity.mr_truncateAll(in: context)
            }) { (changed, error) in
                if let error = error {
                    reject(error)
                }
                else {
                    fulfill(changed)
                }
            }
        }
    }
    
    func last() -> Promise<Location?> {
        return Promise { fulfill, reject in
            let context = NSManagedObjectContext.mr_()
            if let entity = LocationEntity.mr_findFirstOrdered(byAttribute: "createdTime", ascending: false, in: context) {
                fulfill(EntityMapper.location(from: entity))
            }
            else {
                fulfill(nil)
            }
        }
    }
    
    func update(_ location: Location) -> Promise<Bool> {
        return Promise { fulfill, reject in
            MagicalRecord.save({ (context) in
                let predicate = NSPredicate(format: "id = '\(location.id)'")
                if let entity = LocationEntity.mr_findFirst(with: predicate, in: context) {
                    EntityMapper.map(from: location, to: entity)
                }
            }) { (changed, error) in
                if let error = error {
                    reject(error)
                }
                else {
                    fulfill(changed)
                }
            }
        }
    }
}
