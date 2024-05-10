//
//  AccountsDelegate.swift
//  ExpenseTracker
//
//  Created by gowtham-pt2177 on 05/04/24.
//

protocol AccountsRepository
{
    func createAccount( name : String )
    func getAccounts() -> [ Account ]
    func deleteAccount( _ : Account )
}
