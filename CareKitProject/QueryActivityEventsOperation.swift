//
//  QueryActivityEventsOperation.swift
//  CareKitProject
//
//  Created by shan jiang on 2017-04-18.
//  Copyright © 2017 shan jiang. All rights reserved.
//

import CareKit

class QueryActivityEventsOperation: Operation{
    
    fileprivate let store: OCKCarePlanStore
    fileprivate let activityIdentifier: String
    fileprivate let startDate: DateComponents
    fileprivate let endDate: DateComponents
    fileprivate(set) var dailyEvents: DailyEvent?
    
    init(store: OCKCarePlanStore, activityIdentifier: String, startDate: DateComponents, endDate: DateComponents){
        self.store = store
        self.activityIdentifier = activityIdentifier
        self.startDate = startDate
        self.endDate = endDate
    }
    
    override func main(){
        // Do nothing if all the operation has been cancelled
        guard !isCancelled else { return }
        
        // Find the activity with the specific identifier in the store
        guard let activity = findActivity() else { return }
        
        // Create a sempahore to wait for other asynchoronus call to be complete
        let semaphore = DispatchSemaphore(value: 0)
        
        self.dailyEvents = DailyEvent()

        // Query for events for activity between requested dates
        store.enumerateEvents(of: activity, startDate: self.startDate, endDate: self.endDate, handler:{ event, _ in
        //store.enumerateEvents(of: activity, startDate: startDateComponent, endDate: endDateComponent, handler:{ event, _ in
                if let event = event{
                    print("find event: date: \(event.date) --- type: \(event.activity.type) ---- \(event.result)")
                    self.dailyEvents?[event.date].append(event)
                }
            }, completion: {_, _ in
                // use semaphore to signal that the query is complete
                // Increment semaphore count
                semaphore.signal()
            })
        // Wait for the semaphore to be signnaled
        // Decrement semaphore count
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    fileprivate func findActivity() -> OCKCarePlanActivity?{
        // Create a semaphore to wait for the asynchronous call to `findActivity` to complete
        let semaphore = DispatchSemaphore(value: 0)
        var activity: OCKCarePlanActivity?
        
        store.activity(forIdentifier: activityIdentifier) { success, foundActivity, error in
            activity = foundActivity
            if !success{
                print(error?.localizedDescription as Any)
            }
            
            // Use the semaphore to signal that the query is complete
            // Increment semaphore count
            semaphore.signal()
        }
        // Decrement semaphore count
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return activity
    }
}
