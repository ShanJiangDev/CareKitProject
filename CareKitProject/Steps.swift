//
//  Steps.swift
//  CareKitProject
//
//  Created by shan jiang on 2017-04-12.
//  Copyright © 2017 shan jiang. All rights reserved.
//

import CareKit
import ResearchKit

class Steps: AccessmentProtocol, HealthKitProtocol {
    //AccessmentProtocol Properties
    let activityType: ActivityType = .steps
    
    //HealthKitProtocol Properties
    var quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
    var unit = HKUnit.count()

    //AccessmentProtocol Properties
    func createCareCardActivity() -> OCKCarePlanActivity{
        // Create a weekly schedule
        let startDate = DateComponents(year: 2017, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate, occurrencesOnEachDay: [1,1,1,1,1,1,1])
        
        // Get localized String to create Sympton Tracker Activity
        
        let identifier = NSLocalizedString(activityType.rawValue, comment: "")
        let groupIdentifier = NSLocalizedString("BodyAccessment", comment: "")
        let title = NSLocalizedString("Steps", comment: "")
        let text = NSLocalizedString("Number of steps", comment: "")
        let tintColor = UIColor.magenta
        
        let bloodPresureAccessment = OCKCarePlanActivity.assessment(
            withIdentifier: identifier,
            groupIdentifier: groupIdentifier,
            title: title,
            text: text,
            tintColor: tintColor,
            resultResettable: true,
            schedule: schedule,
            userInfo: nil
        )
        
        return bloodPresureAccessment
    }
    
    func task() -> ORKTask {
        //NSLocalizedString for creating ORKQuestionStep
        let title = NSLocalizedString("How many steps have you finished today?", comment: "")
        let text = NSLocalizedString("Enter how many of stpes have you finished below", comment: "")
        // Create ORKNumericaAnswerStyle question format
        let answerFormat = ORKNumericAnswerFormat(style: .integer, unit: "steps")
        
        // Create question step for ORKTask
        let questionStep = ORKQuestionStep(identifier: activityType.rawValue, title: title, text: text, answer: answerFormat)
        questionStep.isOptional = false
        
        // Create an order of task within a single order
        let task = ORKOrderedTask(identifier: activityType.rawValue, steps: [questionStep])
        
        return task
    }
    
    //HealthKitProtocol Properties
    // Create HealthKit Sample for storage
    func buildSampleWithTaskResult(_ result: ORKTaskResult) -> HKQuantitySample {
        // Get the result from accessment
        guard let firstResult = result.firstResult as? ORKStepResult, let finalResult = firstResult.results?.first else{
            fatalError("Unexpected task results")
        }
        
        //Get the numerica answer for the result
        guard let stepResult = finalResult as? ORKNumericQuestionResult, let stepAnswer = stepResult.numericAnswer else {
            fatalError("Unable to determine result answer")
        }
        
        // Create HKQuantitySample
        let quantity = HKQuantity(unit: unit, doubleValue: stepAnswer.doubleValue)
        let now = Date()
        
        return HKQuantitySample(type: quantityType, quantity: quantity, start: now, end: now)
    }
    
    // Create a string using NSMassFormatter to represent the HealthKit sample
    func localizedUnitForSample(_ sample: HKQuantitySample) -> String {
        let formatter = MassFormatter()
        formatter.isForPersonMassUse = true
        formatter.unitStyle = .short
        
        let value = sample.quantity.doubleValue(for: unit)
        let formatterUnit = MassFormatter.Unit.stone
    
        return formatter.unitString(fromValue: value, unit: formatterUnit)
    }
    
    
    
    
    
    
}






























