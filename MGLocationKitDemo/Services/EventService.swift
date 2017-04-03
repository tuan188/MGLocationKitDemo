//
//  EventService.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 4/3/17.
//  Copyright © 2017 Tuan Truong. All rights reserved.
//

import UIKit
import PromiseKit

class EventService {
    
    let eventRepository = EventRepository()
    
    private init() { }
    
    static let sharedInstance = EventService()
    
    func add(content: String) {
        self.add(Event(content: content)).catch { (error) in
            
        }
    }
    
    func add(_ event: Event) -> Promise<Bool> {
        return eventRepository.add(event)
    }
    func all(_ date: Date? = nil) -> Promise<[Event]> {
        return eventRepository.all(date)
    }
    
    func deleteAll() -> Promise<Bool> {
        return eventRepository.deleteAll()
    }
}
