//
//  DailyEvent.swift
//  CareKitProject
//
//  Created by shan jiang on 2017-04-18.
//  Copyright © 2017 shan jiang. All rights reserved.
//

import CareKit

struct DailyEvent {
    fileprivate var mappedEvent: [DateComponents: [OCKCarePlanEvent]]
    
    var allEvents: [OCKCarePlanEvent]{
        return Array(mappedEvent.values.joined())
    }
    
    var allDays: [DateComponents]{
        return Array(mappedEvent.keys)
    }
    
    subscript(day: DateComponents) -> [OCKCarePlanEvent]{
        get{
            if let events = mappedEvent[day]{
                return events
            } else {
                return []
            }
        }
        
        set(newValue){
            mappedEvent[day] = newValue
        }
    }
    
    init(){
        mappedEvent = [:]
    }
}
