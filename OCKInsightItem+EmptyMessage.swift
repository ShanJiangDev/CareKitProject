//
//  OCKInsightItem+EmptyMessage.swift
//  CareKitProject
//
//  Created by shan jiang on 2017-04-18.
//  Copyright © 2017 shan jiang. All rights reserved.
//

import CareKit

// Add an easy way to create an OCKInsightItem to show when no insights have been calculated
//  As an initial content
extension OCKInsightItem{
    static func emptyInsightMessage() -> OCKInsightItem{
        return OCKMessageItem(title: "No insights", text: "There is no insights to show", tintColor: Colors.green.color, messageType: .tip)
    }
}
