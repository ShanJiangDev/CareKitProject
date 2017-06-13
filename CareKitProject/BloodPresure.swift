//
//  BloodPresure.swift
//  CareKitProject
//
//  Created by shan jiang on 2017-04-12.
//  Copyright © 2017 shan jiang. All rights reserved.
//

import CareKit
import ResearchKit

class BloodPresure: AccessmentProtocol {
    //AccessmentProtocol Properties
    let activityType: ActivityType = .bloodPresure

    //AccessmentProtocol Properties
    func createCareCardActivity() -> OCKCarePlanActivity{
        // Create a weekly schedule
        let startDate = DateComponents(year: 2017, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate, occurrencesOnEachDay: [1,1,1,1,1,1,1])
        
        // Get localized String to create Sympton Tracker Activity
        
        let identifier = NSLocalizedString(activityType.rawValue, comment: "")
        let groupIdentifier = NSLocalizedString("BodyAccessment", comment: "")
        let title = NSLocalizedString("BloodPresure", comment: "")
        let text = NSLocalizedString("Enter your blood presure of today", comment: "")
        let tintColor = UIColor.magenta

        let BloodPresureAccessment = OCKCarePlanActivity.assessment(
            withIdentifier: identifier,
            groupIdentifier: groupIdentifier,
            title: title,
            text: text,
            tintColor: tintColor,
            resultResettable: true,
            schedule: schedule,
            userInfo: nil
        )
        
        return BloodPresureAccessment
    }
    
    func task() -> ORKTask {
        //NSLocalizedString for creating ORKQuestionStep
        let title = NSLocalizedString("Blood Presure of the day?", comment: "")
        let text = NSLocalizedString("Enter your blood presure below", comment: "")
        // Create ORKNumericaAnswerStyle question format
        let answerFormat = ORKNumericAnswerFormat(style: .integer, unit: "bp")
        
        // Create question step for ORKTask
        let questionStep = ORKQuestionStep(identifier: activityType.rawValue, title: "", text: text, answer: answerFormat)
        questionStep.isOptional = false
        
        // Create an order of task within a single order
        let task = ORKOrderedTask(identifier: activityType.rawValue, steps: [questionStep])
        
        return task
    }
    

}
