//
//  BuildInsightsOperation.swift
//  CareKitProject
//
//  Created by shan jiang on 2017-04-18.
//  Copyright © 2017 shan jiang. All rights reserved.
//

import CareKit

class BuildInsightsOperation: Operation {
    
    var medicationEvents:   DailyEvent?
    var bloodPresureEvents: DailyEvent?
    
    // An array of InsightItem to show in the InsightsDashBoard view
    fileprivate(set) var insights = [OCKInsightItem.emptyInsightMessage()]

    override func main(){
        print("inside BuildInsightsOperations")
        // Do nothing, return if the operation has been cancelled
        guard !isCancelled else{
            return
        }
        
        // Create a new array of DashBardInsightItems
        var newInsights = [OCKInsightItem]()
        
        // Add medication activity to the insightsArray
        if let insight = createMedicationInsight(){
            newInsights.append(insight)
        }
        // Add bloodpresure accessment to insightsArray
        
        // Store new insights into variable "insights"
        if !newInsights.isEmpty{
            insights = newInsights
        }
    }
    
    // Create Medication activity InsightItem
    func createMedicationInsight() -> OCKInsightItem?{
        print("inside createMedicationInsights")
        // Check if there is any event for parsing
        guard let medicationEvents = medicationEvents else { return nil }
        
        // Get the start date of previous week
        let calendar = Calendar.current
        //let startDatePreviousWeek = calendar.getStartDateOfPreviousWeek()
        
        var totalEventCount = 0
        var completedEventCount = 0
        
        for offset in 0..<7{
            let dayComponent = calendar.dateRangeFromPreviousWeekToNow().start
            let eventsForDay = medicationEvents[dayComponent]
            totalEventCount += eventsForDay.count
            
            for event in eventsForDay{
                if event.state == .completed{
                    completedEventCount += 1
                }
            }
        }
        print("completedEventCount: \(completedEventCount),totalEventCount\(totalEventCount) ")
        guard totalEventCount > 0 else {
            return nil
        }
       
        
        // Calculate the precentage of completed events
        let medicationAdherence = Float(completedEventCount)/Float(totalEventCount)
        // Transfer Float to String with precentage format
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        let formattedAdherence = percentageFormatter.string(from: NSNumber(value: medicationAdherence))
        
        // Create OCKMessageItem
        //  It descirbe medicationAdherence

        
        let bloodPresureMessageItem = OCKMessageItem(title: "Medication Adherence", text: "Your medication adherence was \(formattedAdherence) last week.", tintColor: UIColor.blue, messageType: .tip)
        
        
        
        return bloodPresureMessageItem
        
    }
    // Create bloodPresure accessment InsightItem

}
