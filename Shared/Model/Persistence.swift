//
//  Persistence.swift
//  Shared
//
//  Created by Trevor Piltch on 12/19/20.
//

import CoreData
import CoreSpotlight
import UIKit

// Core Data stuff
var persistentContainer: NSPersistentContainer = {
    var spotlightIndexer: ExpenseSpotlightDelegate?
    let container = NSPersistentContainer(name: "Cashier4")
    
    guard let description = container.persistentStoreDescriptions.first else {
        fatalError("###\(#function): Failed to retrieve a persistent store description.")
    }
    
    description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
    description.type = NSSQLiteStoreType
    
    container.loadPersistentStores(completionHandler: { (_, error) in
        guard let error = error as NSError? else { return }
        fatalError("###\(#function): Failed to load persistent stores: \(error)")
    }
    )
    
    spotlightIndexer = ExpenseSpotlightDelegate(forStoreWith: description, coordinator: container.persistentStoreCoordinator)
    
    spotlightIndexer?.startSpotlightIndexing()
    
    return container
}()


struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let newCard = CreditCard(context: viewContext)
        newCard.name = "Testing"
        newCard.company = "norway"
        newCard.number = "1234-5678-0000"
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer = NSPersistentContainer(name: "Cashier4")

    init(inMemory: Bool = false) {
        print("In Memory")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

class ExpenseSpotlightDelegate: NSCoreDataCoreSpotlightDelegate {
//    override func indexName() -> String? {
//        return "item-index"
//    }
    
    override func attributeSet(for object: NSManagedObject) -> CSSearchableItemAttributeSet? {
        let model = ExpenseModel()
        
        let expense = model.getValue(obj: object)
        
        let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        
        attributeSet.identifier =  expense.item
        attributeSet.displayName = "$\(expense.amount): \(expense.item)"
        attributeSet.contentDescription = dateFormatter.string(from: expense.date)
        attributeSet.thumbnailData = UIImage(named: "Expense")?.pngData()
        
        
        for tag in expense.tags {
            attributeSet.keywords?.append(tag)
        }
        
        return attributeSet
    }
}
