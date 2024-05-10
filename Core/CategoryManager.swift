//
//  CategoryManager.swift
//  ExpenseTracker
//
//  Created by gowtham-pt2177 on 05/04/24.
//

import Foundation

class CategoryManager : CategoryRepository
{
    static let shared = CategoryManager()
    
    private init() {}
    
    func createCategory(name: String, transactionType: String, account : Account) {
        if validateInsertOperation( name : name, transactionType: transactionType, account: account)
        {
            let category = Category(context: PersistentStorage.shared.context)
            category.name = name
            category.transactionType = transactionType
            category.account = account
            PersistentStorage.shared.saveContext()
        }
    }
    
    private func validateInsertOperation( name : String, transactionType : String, account : Account ) -> Bool
    {
        let predicate = NSPredicate( format: "name == %@ And transactionType == %@ And account == %@", name, transactionType, account)
        return ( PersistentStorage.shared.fetchManagedObject(managedObject: Category.self, predicate: predicate) ?? [] ).isEmpty
    }
    
    func getCategories( forAccount account : Account, ofTransactionType type : String? = nil ) -> [ Category ] {
        let predicate = getCategoryPredicate(account: account, ofTransactionType: type)
        return PersistentStorage.shared.fetchManagedObject(managedObject: Category.self, predicate: predicate) ?? []
    }
    
    private func getCategoryPredicate( account : Account, ofTransactionType type : String? ) -> NSPredicate
    {
        let accountPredicate = NSPredicate( format: "account = %@", account )
        var combinedPredicate : NSPredicate
        if let transactionType = type
        {
            let transactionPredicate = NSPredicate( format: "transactionType == %@", transactionType )
            combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [accountPredicate, transactionPredicate])
        }
        else 
        {
            combinedPredicate = accountPredicate
        }
        return combinedPredicate
    }
    
    func deleteCategory( _ category : Category) {
        PersistentStorage.shared.context.delete( category )
        PersistentStorage.shared.saveContext()
    }
}
