//
//  Transaction+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by gowtham-pt2177 on 10/04/24.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: Date
    @NSManaged public var note: String
    @NSManaged public var account: Account
    @NSManaged public var category: Category

}

extension Transaction : Identifiable {

}

extension Transaction
{
    enum sortBy : String
    {
        case date
        case amount
        case categoryName = "category.name"
    }
    
    enum sortOrder
    {
        case asc
        case desc
        
        var value : Bool {
            switch self
            {
            case .asc : return true
            case .desc : return false
            }
        }
    }
}
