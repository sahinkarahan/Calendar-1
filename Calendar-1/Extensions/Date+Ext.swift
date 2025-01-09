//
//  Date+Ext.swift
//  Calendar-1
//
//  Created by Şahin Karahan on 8.01.2025.
//

import Foundation

extension Date {
    
    
    
    
    func datesOfMonth() -> [Date] {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: self)
        let currentYear = calendar.component(.year, from: self)
        
        var startDateComponents = DateComponents()
        startDateComponents.year = currentYear
        startDateComponents.month = currentMonth
        startDateComponents.day = 1
        let startDate = calendar.date(from: startDateComponents)!
        
        var endDateComponents = DateComponents()
        endDateComponents.month = 1
        endDateComponents.day = -1
        let endDate = calendar.date(byAdding: endDateComponents, to: startDate)!
        
        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
            return dates
    }
    
    func monthYearFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        return formatter.string(from: self)
    }
    
    func monthDayYearFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM//dd//yyyy"
        return formatter.string(from: self)
    }
    
    func fullMonthDayYearFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: self)
    }
    
    func dayOfTheWeek() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
    
    func timeFromDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: self)
    }
    
    func bookingViewDateFormat() -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        
        let start = timeFormatter.string(from: self)
        let endDate = Calendar.current.date(byAdding: .minute, value: 30, to: self)!
        
        let end = timeFormatter.string(from: endDate)
        
        let day = self.dayOfTheWeek()
        let fullDateString = self.fullMonthDayYearFormat()
        
        return "\(start) - \(end), \(day), \(fullDateString)"
    }
    
}
