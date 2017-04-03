//
//  EntityMapper.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 3/31/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit

struct EntityMapper {
    static func map(from location: Location, to entity: LocationEntity) {
        entity.id = location.id
        entity.lat = location.lat
        entity.lng = location.lng
        entity.createdTime = location.createdTime as NSDate
        entity.arrivalTime = location.arrivalTime as NSDate?
        entity.departureTime = location.departureTime as NSDate?
        entity.transport = location.transport
        entity.isCard = location.isCard
    }
    
    static func location(from entity: LocationEntity) -> Location {
        return Location(
            id: entity.id!,
            lat: entity.lat,
            lng: entity.lng,
            createdTime: entity.createdTime! as Date,
            arrivalTime: entity.arrivalTime as Date?,
            departureTime: entity.departureTime as Date?,
            transport: entity.transport,
            isCard: entity.isCard
        )
    }
    
    static func map(from event: Event, to entity: EventEntity) {
        entity.id = event.id
        entity.createdTime = event.createdTime as NSDate
        entity.content = event.content
    }
    
    static func event(from entity: EventEntity) -> Event {
        return Event(id: entity.id!, createdTime: entity.createdTime! as Date, content: entity.content!)
    }
}
