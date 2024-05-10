//
//  CategoryDelegate.swift
//  ExpenseTracker
//
//  Created by gowtham-pt2177 on 05/04/24.
//

protocol CategoryRepository
{
    func createCategory( name : String, transactionType : String, account : Account )
    func getCategories( forAccount : Account, ofTransactionType : String? ) -> [ Category ]
    func deleteCategory( _ : Category )
}
