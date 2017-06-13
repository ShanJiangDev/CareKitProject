//
//  ActivityProtocol.swift
//  CareKitProject
//
//  Created by shan jiang on 2017-04-10.
//  Copyright © 2017 shan jiang. All rights reserved.
//

import CareKit


protocol ActivityProtocol {
    var activityType: ActivityType{ get }
    
    func createCareCardActivity() -> OCKCarePlanActivity

}

enum ActivityType: String {
    case transplantMedication
    case morningHeart
    case nightBlood
    case headache
    case bloodPresure
    case steps

}

