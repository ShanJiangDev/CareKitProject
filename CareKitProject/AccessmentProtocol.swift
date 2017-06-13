//
//  AccessmentProtocol.swift
//  CareKitProject
//
//  Created by shan jiang on 2017-04-10.
//  Copyright © 2017 shan jiang. All rights reserved.
//

import CareKit
import ResearchKit

protocol AccessmentProtocol: ActivityProtocol {
    func task() -> ORKTask
}

extension AccessmentProtocol {
    
    func buildResultForCarePlanEvent(_ event: OCKCarePlanEvent, taskResult: ORKTaskResult) -> OCKCarePlanEventResult{
        // Get the first result for the first step of the task result
        
        // taskResult comes from ORKTaskResult : ORKCollectionResult, ORKTaskResultSource
        // `ORKTaskResult` object is a collection result that contains all the step results generated from one run of a task or ordered task (that is, `ORKTask` or `ORKOrderedTask`) in a task view controller.
        
        // taskResult.firstResult from ORKCollectionResult
        
        // taskResult.firstResult.results? has an array of ORKResult
        
        // taskResult.firstResult.result?. first: get the first one of this collection

        guard let firstResult = taskResult.firstResult as? ORKStepResult, let stepResult = firstResult.results?.first else{
            fatalError("Unexpected task results")
        }

        // Generate OCKCarePlanEventResult object based on the type of the result
        // If the result get from scale
        if let scaleResult = stepResult as? ORKScaleQuestionResult, let answer = scaleResult.scaleAnswer{
            return OCKCarePlanEventResult(valueString: answer.stringValue, unitString: "out of 10", userInfo: nil)
        // If the result get from Numerica Question
        }else if let numericResult = stepResult as? ORKNumericQuestionResult, let answer = numericResult.numericAnswer {
            return OCKCarePlanEventResult(valueString: answer.stringValue, unitString: numericResult.unit, userInfo: nil)
        }
        fatalError("Unexpected task results")

        
        
    }
}

















































