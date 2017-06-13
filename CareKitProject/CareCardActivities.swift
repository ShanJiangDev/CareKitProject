//
//  CareCardActivities.swift
//  CareKitProject
//
//  Created by shan jiang on 2017-04-10.
//  Copyright © 2017 shan jiang. All rights reserved.
//

import CareKit

class CareCardActivities: NSObject {

    
    let activities : [ActivityProtocol] = [
        TransplantMedication(),
        MorningHeart(),
        NightBlood(),
        Headache(),
        BloodPresure(),
        Steps()
    ]
    
    func activityWithType(_ type: ActivityType) -> ActivityProtocol?{
        for activity in activities{
            if activity.activityType == type {
                return activity
            }
        }
        return nil
    }
    
    

}
