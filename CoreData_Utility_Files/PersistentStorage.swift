//
//  PersistentStorage.swift
//  ZCRM_iOS_SDK
//
//  Created by gowtham-pt2177 on 29/03/24.
//

import Foundation
import CoreData

final class PersistentStorage
{
    static let shared = PersistentStorage()
    private init() {}
    
    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ExpenseTracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchManagedObject< T : NSManagedObject >( managedObject : T.Type, predicate : NSPredicate? = nil, sortDescriptor : NSSortDescriptor? = nil ) -> [T]?
    {
        do
        {
            let entityName = String(describing: managedObject.self)
            let fetchRequest = NSFetchRequest<T>(entityName: entityName)
            fetchRequest.predicate = predicate
            if let sortDescriptor
            {
                fetchRequest.sortDescriptors = [ sortDescriptor ]
            }
            let result = try PersistentStorage.shared.context.fetch( fetchRequest )
            
            return result
        }
        catch
        {
            print("Error : \( error )")
        }
        return nil
    }
} // Global Search
