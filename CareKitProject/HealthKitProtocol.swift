//
//  HealthKitProtocol.swift
//  CareKitProject
//
//  Created by shan jiang on 2017-04-12.
//  Copyright © 2017 shan jiang. All rights reserved.
//

import ResearchKit

protocol HealthKitProtocol {
    var quantityType: HKQuantityType { get }
    var unit: HKUnit { get }
    func buildSampleWithTaskResult(_ result: ORKTaskResult) -> HKQuantitySample
    func localizedUnitForSample(_ sample: HKQuantitySample) -> String
}
