//
//  TransactionManager.swift
//  ExpenseTracker
//
//  Created by gowtham-pt2177 on 05/04/24.
//

import Foundation

class TransactionManager : TransactionRepository
{
    static let shared = TransactionManager()
    
    private init() {}
    
    func createTransaction( amount : Double, date : Date, note : String = "", category : Category, account : Account ) {
        let transaction = Transaction(context: PersistentStorage.shared.context)
        transaction.amount = amount
        transaction.date = date
        transaction.note = note
        transaction.category = category
        transaction.account = account
        PersistentStorage.shared.saveContext()
    }
    
    func getTransactions( forDateRange period : ExpenseTrackerUtil.Period, forAccount account  : Account, byCategory category : Category? = nil, sortBy : String? = nil, sortOrder : Bool? = nil ) -> TransactionResult {
        let currentTransactions = getCurrentTransactions(forDateRange: period, forAccount: account, byCategory: category, sortBy: sortBy, sortOrder: sortOrder)
        let previousTransactions = getPreviousTransactions(forDateRange: period, forAccount: account, byCategory: category)
        let metaData = getMetaData( currentTransactions: currentTransactions, previousTrasactions: previousTransactions )
        return TransactionResult(transactions: currentTransactions, metaData: metaData)
    }
    
    private func getCurrentTransactions( forDateRange period : ExpenseTrackerUtil.Period, forAccount account  : Account, byCategory category : Category? = nil, sortBy : String? = nil, sortOrder : Bool? = nil ) -> [ Transaction ] {
        let predicate = getTransactionPredicate( dateRange : period, account: account, category: category, dateRangePredicate: .range )
        let sortDescriptor = getSortDescriptor(sortBy: sortBy, sortOrder: sortOrder)
        return PersistentStorage.shared.fetchManagedObject(managedObject: Transaction.self, predicate: predicate, sortDescriptor: sortDescriptor) ?? []
    }
    
    private func getPreviousTransactions( forDateRange period : ExpenseTrackerUtil.Period, forAccount account  : Account, byCategory category : Category? = nil ) -> [ Transaction ] {
        let predicate = getTransactionPredicate( dateRange : period, account: account, category: category, dateRangePredicate: .previous )
        return PersistentStorage.shared.fetchManagedObject(managedObject: Transaction.self, predicate: predicate) ?? []
    }
    
    private func getMetaData( currentTransactions : [ Transaction ], previousTrasactions : [ Transaction ] ) -> MetaData {
        var metaData = MetaData()
        currentTransactions.forEach() { transaction in
            if transaction.category.transactionType == "income" {
                metaData.totalIncome += transaction.amount
            } else {
                metaData.totalExpense += transaction.amount
            }
        }
        previousTrasactions.forEach() { transaction in
            if transaction.category.transactionType == "income" {
                metaData.carryOver += transaction.amount
            } else {
                metaData.carryOver += transaction.amount
            }
        }
        metaData.balance = metaData.totalIncome - metaData.totalExpense
        return metaData
    }
    
    func deleteTransaction( _ transaction : Transaction) {
        PersistentStorage.shared.context.delete( transaction )
        PersistentStorage.shared.saveContext()
    }
    
    func deleteTransactions( _ category : Category )
    {
        let predicate = NSPredicate(format: "category == %@", category)
        let transactions = PersistentStorage.shared.fetchManagedObject(managedObject: Transaction.self, predicate: predicate) ?? []
        for transaction in transactions
        {
            PersistentStorage.shared.context.delete( transaction )
        }
        PersistentStorage.shared.saveContext()
    }
}

extension TransactionManager
{
    private func getTransactionPredicate( dateRange : ExpenseTrackerUtil.Period, account : Account, category : Category?, dateRangePredicate : ExpenseTrackerUtil.Period.predicate ) -> NSPredicate
    {
        let accountPredicate = NSPredicate(format: "account = %@", account)
        let ( startDate, endDate ) = dateRange.range
        let dateRangePredicate = NSPredicate(format: dateRangePredicate.rawValue, startDate as NSDate, endDate as NSDate )
        var categoryPredicate: NSPredicate?
        if let category = category {
            categoryPredicate = NSPredicate(format: "category = %@", category)
        }
        var combinedPredicate: NSPredicate = accountPredicate

        if let categoryPredicate = categoryPredicate {
            combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [accountPredicate, categoryPredicate, dateRangePredicate])
        }
        else
        {
            combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [accountPredicate, dateRangePredicate])
        }
        return combinedPredicate
    }
    
    private func getSortDescriptor( sortBy : String?, sortOrder : Bool? ) -> NSSortDescriptor?
    {
        var sortDescriptor : NSSortDescriptor?
        if let sortBy = sortBy
        {
             sortDescriptor = NSSortDescriptor(key: sortBy, ascending: sortOrder ?? true)
        }
        return sortDescriptor
    }
}


public struct MetaData
{
    public var totalIncome : Double = 0
    public var totalExpense : Double = 0
    public var balance : Double = 0
    public var carryOver : Double = 0
}
