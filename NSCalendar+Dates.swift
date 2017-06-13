//
//  NSCalendar+Dates.swift
//  CareKitProject
//
//  Created by shan jiang on 2017-04-16.
//  Copyright © 2017 shan jiang. All rights reserved.
//

import Foundation

extension Calendar {
    /**
     Returns a tuple containing the start and end dates for the week that the
     specified date falls in.
     */
    func weekDatesForDate(_ date: Date) -> (start: Date, end: Date) {
        var interval: TimeInterval = 0
        var start: Date = Date()
        _ = dateInterval(of: .weekOfYear, start: &start, interval: &interval, for: date)
        let end = start.addingTimeInterval(interval)
        
        return (start as Date, end as Date)
    }
    
    func getWeekNumber() -> Int {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        return weekOfYear
    }
    
    func getStartDateOfPreviousWeek() -> Date {
        let calendar = Calendar.current
        let date = Date()
        let currentWeekNum = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        var dateComponent = calendar.dateComponents([.year,.weekOfYear, .weekday], from: date)
        
        dateComponent.weekday = 2
        dateComponent.weekOfYear = currentWeekNum - 1
        
        let lastMonday = calendar.date(from: dateComponent)

        return lastMonday!
    }
    
    func dateComponentOfPreviousWeekDay(dayNumber: Int) -> DateComponents{
        let calendar = Calendar.current
        let date = Date()
        let currentWeekNum = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        var dateComponent = calendar.dateComponents([.year,.day, .weekOfYear, .weekday], from: date)
        let day = dateComponent.day!
        
        dateComponent.weekday = 2
        dateComponent.weekOfYear = currentWeekNum - 1
        dateComponent.day = day + dayNumber
        
        return dateComponent
    }
    
    func dateRangeFromPreviousWeekToNow() -> (start:DateComponents, end: DateComponents){
        let calendar = Calendar.current
        let date = Date()

        var endDateComponent = calendar.dateComponents([.year, .month, .day], from: date)
        var startDateComponent = endDateComponent
        
        if endDateComponent.day! - 6 > 0 {
            startDateComponent.day = endDateComponent.day! - 6
        } else if endDateComponent.isLeapMonth! {
            startDateComponent.month = endDateComponent.month! - 1
            startDateComponent.day = 30 - 6 + endDateComponent.day!
        }
        
        return(start: startDateComponent, end: endDateComponent )
    }
}
