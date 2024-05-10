//
//  ExpenseTrackerUtil.swift
//  ExpenseTracker
//
//  Created by gowtham-pt2177 on 05/04/24.
//

import Foundation

class ExpenseTrackerUtil
{
    static let shared = ExpenseTrackerUtil()
    
    private init() {}
    
    func createAccount( _ name : String )
    {
        AccountsManager.shared.createAccount( name: name )
    }
    
    func getAccounts() -> [ Account ]
    {
        AccountsManager.shared.getAccounts()
    }
    
    public enum Period
    {
        case day
        case week
        case month
        case year
        case custom( from : Date, to  : Date )
        
        var calendar : Calendar {
            return Calendar.current
        }
        
        var components : DateComponents
        {
            switch self
            {
            case .day:
                return DateComponents(day: 1)
            case .week:
                return DateComponents(day: 7)
            case .month:
                return DateComponents(month: 1)
            case .year:
                return DateComponents(year: 1)
            case .custom(from: let from, to: let to):
                let components = calendar.dateComponents([.year, .month, .day], from: from, to: to)
                return components
            }
        }
        
        var range : ( startday : Date, endDay : Date )
        {
            switch self
            {
            case .day:
                let startDate = calendar.date(from: calendar.dateComponents([ .year, .month, .day], from: Date()))!
                let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
                return ( startDate, endDate )
            case .week:
                let startDate = calendar.date(from: calendar.dateComponents([ .yearForWeekOfYear, .weekOfYear ], from: Date()))!
                let endDate = calendar.date(byAdding: .day, value: 7, to: startDate)!
                return ( startDate, endDate )
            case .month:
                let startDate = calendar.date(from: calendar.dateComponents([ .year, .month ], from: Date()))!
                let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)!
                return ( startDate, endDate )
            case .year:
                let startDate = calendar.date(from: calendar.dateComponents([ .year ], from: Date()))!
                let endDate = calendar.date(byAdding: DateComponents(year: 1, day: -1), to: startDate)!
                return ( startDate, endDate )
            case .custom(from: let from, to: let to):
                return ( from, to )
            }
        }
        
        enum predicate : String
        {
            case range = "date >= %@ AND date < %@"
            case previous = "date < %@"
        }
    }
}
