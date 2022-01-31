//
//  Date+Extensions.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 23.01.2022.
//  Copyright © 2022 Tripian Inc. All rights reserved.
//

import Foundation
extension Date {
    
    /// Date tipindeki veriyi String tipine dönüştürür.
    ///
    /// - Parameter format: Date formatı
    /// - Returns: Date to String
    func toString(format: String? = nil, dateStyle: DateFormatter.Style? = nil, timeStyle: DateFormatter.Style? = nil) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        if let f = format {
            formatter.dateFormat = f
        }
        if let ts = timeStyle {
            formatter.timeStyle = ts
        }
        if let ds = dateStyle   {
            formatter.dateStyle = ds
        }
        return formatter.string(from: self)
    }
    
    func toStringWithoutTimeZone(format: String? = nil, dateStyle: DateFormatter.Style? = nil, timeStyle: DateFormatter.Style? = nil) -> String {
        let formatter = DateFormatter()
        if let f = format {
            formatter.dateFormat = f
        }
        if let ts = timeStyle {
            formatter.timeStyle = ts
        }
        if let ds = dateStyle   {
            formatter.dateStyle = ds
        }
        return formatter.string(from: self)
    }

    
    //Tarihin gununu dondurur. -> Mon, Tue, Wed..
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    //Bugunun gununu sayi olarak dondurur.
    func dayNumberOfWeek() -> Int? {
        return Calendar.currentWithUTC.dateComponents([.weekday], from: self).weekday
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    func addMin(component: Calendar.Component, value: Int) -> Date?{
        let calendar = Calendar.current
        let next = calendar.date(byAdding: component, value: value, to: self)
        return next
    }
    
    func addDay(_ day: Int) -> Date? {
        var dayComponent = DateComponents()
        dayComponent.day = day
        
        return Calendar.currentWithUTC.date(byAdding: dayComponent, to: self)
    }
    
    
    
    func addHour(_ hours: Int) -> Date? {
        var dayComponent = DateComponents()
        dayComponent.hour = hours
        return Calendar.currentWithUTC.date(byAdding: dayComponent, to: self)
    }
    
    func addHour(_ hours: Int, minutes: Int) -> Date? {
        var dayComponent = DateComponents()
        dayComponent.hour = hours
        dayComponent.minute = minutes
        return Calendar.currentWithUTC.date(byAdding: dayComponent, to: self)
    }
    

    func setHour(_ hours: Int, minutes: Int) -> Date? {
        Calendar.currentWithUTC.date(bySettingHour: hours, minute: minutes, second: 0, of: self)!
    }
}

