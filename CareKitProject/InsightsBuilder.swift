//
//  InsightsBuilder.swift
//  CareKitProject
//
//  Created by shan jiang on 2017-04-18.
//  Copyright © 2017 shan jiang. All rights reserved.
//

import CareKit

class InsightsBuilder{
    //An array of OCKInsightItem to show on the InsightsDashBoardView
    fileprivate(set) var insights = [OCKInsightItem.emptyInsightMessage()]
    
    fileprivate let carePlanStore: OCKCarePlanStore
    fileprivate let updateOperationQueue = OperationQueue()
    
    required init(carePlanStore: OCKCarePlanStore){
        self.carePlanStore = carePlanStore
    }
    
    // Enqueue NSOperation s to query OCKCarePlanStore and update Insights property
    func updateInsights(_ completion:((Bool, [OCKInsightItem]?) -> Void)?){
        
        //Cancle all in-progress operations
        updateOperationQueue.cancelAllOperations()
        
        //Create query range, include last week and current week
        let calendar = Calendar.current
        let queryRange = calendar.dateRangeFromPreviousWeekToNow()
        
        // Create an operation to query for events of queryRange for NightBlood activity
        let medicationEventsOperation = QueryActivityEventsOperation(store: carePlanStore,
                                                                     activityIdentifier: ActivityType.nightBlood.rawValue,
                                                                     startDate: queryRange.start,
                                                                     endDate: queryRange.end)
        
        // Create a BuildInsightsOperation variable to create insights from the data collectd by QueryActivityEventOperation
        
        let buildInsightsOperation = BuildInsightsOperation()
        
        // Create an Operation to aggregate the data from QueryActivityEventOperation
        let aggregateDataOperation = BlockOperation{
            buildInsightsOperation.bloodPresureEvents = medicationEventsOperation.dailyEvents
        }
        
        // Use the completion block of the buildInsightsOperation to store the new insights and call the completion block passed to this method
        
        // Unowned: Use an unowned reference only when you are sure that the reference always refers to an instance that has not been deallocated.
        // Unowned: If you try to access the value of an unowned reference after that instance has been deallocated, you’ll get a runtime error.
        buildInsightsOperation.completionBlock = {[unowned buildInsightsOperation] in
            let completed = !buildInsightsOperation.isCancelled
            let newInsights = buildInsightsOperation.insights
            
            //Call the completion block on the main queue
            OperationQueue.main.addOperation {
                if completed {
                    completion?(true, newInsights)
                } else {
                    completion?(false, nil)
                }
            }
        }
        // Aggregate Operation is dependent on the query operation
        aggregateDataOperation.addDependency(medicationEventsOperation)
        
        // BuildInsightsOperation is depend on the aggregateDataOperation
        buildInsightsOperation.addDependency(aggregateDataOperation)
        
        //Add all the operation to the operation queue
        updateOperationQueue.addOperations([medicationEventsOperation,
                                            aggregateDataOperation,
                                            buildInsightsOperation], waitUntilFinished: false)
        
    }
}

protocol InsightsBuilderDelegate: class {
    func insightsBuilder(_ insightsBuilder: InsightsBuilder, didUpdateInsights insights: [OCKInsightItem])
}
