//
//  CalendarHelper.swift
//  Laundry
//
//  Created by chanakya hirpara on 2/23/19.
//  Copyright © 2019 chanakya hirpara. All rights reserved.
//

import Foundation

class CalendarHelper{
    static func datesBetween(_ startDate: Date, _ endDate: Date, format:String = "yyyy-MM-dd") -> [Date] {
        
        var dateList : [Date] = []
        
        var startDate = startDate
        let calendar = Calendar.current
        
        let fmt = DateFormatter()
        fmt.dateFormat = format
        
        while startDate <= endDate {
            //print(fmt.string(from: startDate))
            if let date = calendar.date(byAdding: .day, value: 1, to: startDate) {
                dateList.append(date)
            }
            startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        }
        
        return dateList
    }
    
    static func printDates(dates:[Date], format:String = "yyyy-MM-dd") {
        let fmt = DateFormatter()
        fmt.dateFormat = format
        
        for eachDate in dates {
            print(fmt.string(from: eachDate))
        }
    }
    
    static func dateFromString(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.date(from: dateString)!
    }
}
