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
    
    func all() -> Promise<[Location]> {
        return Promise { fulfill, reject in
            let context = NSManagedObjectContext.mr_()
            var locations = [Location]()
            if let entities = LocationEntity.mr_findAllSorted(by: "createdTime", ascending: true, in: context) as? [LocationEntity] {
                for entity in entities {
                    locations.append(EntityMapper.location(from: entity))
                }
            }
            fulfill(locations)
        }
    }
}
