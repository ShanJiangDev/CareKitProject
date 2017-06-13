//
//  MorningHeart.swift
//  CareKitProject
//
//  Created by shan jiang on 2017-04-10.
//  Copyright © 2017 shan jiang. All rights reserved.
//

import CareKit


class MorningHeart: ActivityProtocol{
    let activityType: ActivityType = .morningHeart
    
    func createCareCardActivity() -> OCKCarePlanActivity{
        // Get the localized strings to use for the activity.
        let identifier = NSLocalizedString(activityType.rawValue, comment: "")
        let groupIdentifier = NSLocalizedString("HeartAndBlood", comment: "")
        let title = NSLocalizedString("Morning Heart Medication", comment: "")
        let text = NSLocalizedString("Two type pills", comment: "")
        let tintColor = UIColor.orange
        let instruction = NSLocalizedString("Take all the morning heart pills", comment: "")
        
        // Create a weekly schedule.
        let startDate = DateComponents(year: 2017, month: 01, day: 01)
        let schedule = OCKCareSchedule.weeklySchedule(withStartDate: startDate as DateComponents, occurrencesOnEachDay: [1,1,1,1,1,1,1])
        
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
