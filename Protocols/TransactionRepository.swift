//
//  TransactionDelegate.swift
//  ExpenseTracker
//
//  Created by gowtham-pt2177 on 05/04/24.
//

import Foundation

protocol TransactionRepository
{
    func createTransaction( amount : Double, date : Date, note : String, category : Category, account : Account )
    func getTransactions( forDateRange : ExpenseTrackerUtil.Period, forAccount : Account, byCategory : Category?, sortBy : String?, sortOrder : Bool? ) -> TransactionResult
    func deleteTransaction( _ : Transaction )
}
