//
//  Account+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by gowtham-pt2177 on 10/04/24.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var name: String
    @NSManaged public var categories: NSSet

}

// MARK: Generated accessors for categories
extension Account {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: Category)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: Category)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}

extension Account : Identifiable {

}

extension Account
{
    func addCategory( name : String, transactionType : Category.TransactionType )
    {
        CategoryManager.shared.createCategory(name: name, transactionType: transactionType.rawValue, account: self)
    }
    
    func getCategories( ofTransactionType type : Category.TransactionType? = nil ) -> [ Category ]
    {
        CategoryManager.shared.getCategories( forAccount: self, ofTransactionType : type?.rawValue )
    }
    
    func addTransaction( amount : Double, date : Date, note : String = "", category : Category )
    {
        TransactionManager.shared.createTransaction(amount: amount, date: date, note: note, category: category, account : self)
    }
    
    func getTransactions( forDateRange period : ExpenseTrackerUtil.Period, byCategory category : Category? = nil, sortBy : Transaction.sortBy? = nil, sortOrder : Transaction.sortOrder? = nil ) -> TransactionResult
    {
        TransactionManager.shared.getTransactions( forDateRange: period, forAccount: self, byCategory: category, sortBy: sortBy?.rawValue, sortOrder: sortOrder?.value )
    }
    
    func deleteTransaction( _ transaction : Transaction )
    {
        TransactionManager.shared.deleteTransaction( transaction )
    }
    
    func delete()
    {
        AccountsManager.shared.deleteAccount( self )
    }
}
