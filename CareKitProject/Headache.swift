//
//  Headache.swift
//  CareKitProject
//
//  Created by shan jiang on 2017-04-10.
//  Copyright © 2017 shan jiang. All rights reserved.
//

import CareKit
import ResearchKit

class Headache: AccessmentProtocol {
    let activityType: ActivityType = .headache
    
    func createCareCardActivity() -> OCKCarePlanActivity{
        // Get the localized strings to use for the activity.
        let identifier = NSLocalizedString(activityType.rawValue, comment: "")
        let groupIdentifier = NSLocalizedString("BodyAccessment", comment: "")
        let title = NSLocalizedString("Headache", comment: "")
        let text = NSLocalizedString("How is your headache?", comment: "")
        let tintColor = UIColor.green
        //let instruction = NSLocalizedString("Take all the transplant Medications", comment: "")
        
        // Create a weekly schedule.
        let startDate = DateComponents(year: 2017, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate as DateComponents, occurrencesOnEachDay: [1,1,1,1,1,1,1])
        
        // Create the accessment activity.
        let headacheAccessment = OCKCarePlanActivity.assessment(
            withIdentifier: identifier,
            groupIdentifier: groupIdentifier,
            title: title,
            text: text,
            tintColor: tintColor,
            resultResettable: true,
            schedule: schedule,
            userInfo: nil)
        
        return headacheAccessment
    }
    
    func task() -> ORKTask {
        //Get the localized strings to use for the ORKTask.
        let question = NSLocalizedString("Do you have headache today?", comment: "")
        let maxValueDescription = NSLocalizedString("Very much", comment: "")
        let minValueDescription = NSLocalizedString("Not at all", comment: "")
        
    
        
        // Create answer format
        let answerFormat = ORKScaleAnswerFormat(
            maximumValue: 10,
            minimumValue: 0,
            defaultValue: -1,
            step: 1,
            vertical: false,
            maximumValueDescription: maxValueDescription,
            minimumValueDescription: minValueDescription
        )
        
        // Create first step of question
        let questionStep = ORKQuestionStep(identifier: activityType.rawValue, title: question, answer: answerFormat)
        questionStep.isOptional = false
        
        // Creae an ordered task with a single question
        let task = ORKOrderedTask(identifier: activityType.rawValue, steps: [questionStep])
        
        return task
        
    }

}
