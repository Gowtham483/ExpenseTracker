//
//  AccountsManager.swift
//  ExpenseTracker
//
//  Created by gowtham-pt2177 on 05/04/24.
//

import Foundation
import CoreData

class AccountsManager : AccountsRepository
{
    static let shared = AccountsManager()
    
    private init() {}
    
    func createAccount(name: String) {
        let account = Account(context: PersistentStorage.shared.context)
        account.name = name
        account.categories = []
        PersistentStorage.shared.saveContext()
    }
    
    func getAccounts() -> [Account] {
        return PersistentStorage.shared.fetchManagedObject(managedObject: Account.self) ?? []
    }
    
    func deleteAccount( _ account : Account ) {
        PersistentStorage.shared.context.delete( account )
        PersistentStorage.shared.saveContext()
    }
}
