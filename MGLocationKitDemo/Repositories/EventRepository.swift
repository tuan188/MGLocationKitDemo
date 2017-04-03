//
//  EventRepository.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 4/3/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit
import PromiseKit
import MagicalRecord

class EventRepository {
    func add(_ event: Event) -> Promise<Bool> {
        return Promise { fulfill, reject in
            MagicalRecord.save({ (context) in
                if let entity = EventEntity.mr_createEntity(in: context) {
                    EntityMapper.map(from: event, to: entity)
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
    func all(_ date: Date? = nil) -> Promise<[Event]> {
        return Promise { fulfill, reject in
            let context = NSManagedObjectContext.mr_()
            var locations = [Event]()
            var entities: [EventEntity]?
            if let date = date {
                let predicate = NSPredicate(format: "createdTime >= %@ && createdTime < %@", date.date as NSDate, date.tomorrow.date as NSDate)
                entities = EventEntity.mr_findAllSorted(by: "createdTime", ascending: false, with: predicate, in: context) as? [EventEntity]
            }
            else {
                entities = EventEntity.mr_findAllSorted(by: "createdTime", ascending: false, in: context) as? [EventEntity]
            }
            if let entities = entities  {
                for entity in entities {
                    locations.append(EntityMapper.event(from: entity))
                }
            }
            fulfill(locations)
        }
    }
    
    func deleteAll() -> Promise<Bool> {
        return Promise { fulfill, reject in
            MagicalRecord.save({ (context) in
                EventEntity.mr_truncateAll(in: context)
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
