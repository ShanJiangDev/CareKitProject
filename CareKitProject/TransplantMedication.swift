//
//  MorningTransplantMedication.swift
//  CareKitProject
//
//  Created by shan jiang on 2017-04-10.
//  Copyright © 2017 shan jiang. All rights reserved.
//

import CareKit


class TransplantMedication: ActivityProtocol{
    let activityType: ActivityType = .transplantMedication

    func createCareCardActivity() -> OCKCarePlanActivity{
        // Get the localized strings to use for the activity.
        let identifier = NSLocalizedString(activityType.rawValue, comment: "")
        let groupIdentifier = NSLocalizedString("TransplantMedication", comment: "")
        let title = NSLocalizedString("Transplant Medication", comment: "")
        let text = NSLocalizedString("CellCept, Prograf", comment: "")
        let tintColor = UIColor.blue
        let instruction = NSLocalizedString("Take all the transplant Medications", comment: "")
        
        // Create a weekly schedule.
        let startDate = DateComponents(year: 2017, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate as DateComponents, occurrencesOnEachDay: [2,2,2,2,2,2,2])
        
        // Create the intervention activity.
        let careCardActivity = OCKCarePlanActivity.intervention(
            withIdentifier: identifier,
            groupIdentifier: groupIdentifier,
            title: title,
            text: text,
            tintColor: tintColor,
            instructions: instruction,
            imageURL: nil,
            schedule: schedule,
            userInfo: nil)
        return careCardActivity
    }
}
