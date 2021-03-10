//
//  Card.swift
//  Cashier
//
//  Created by Trevor Piltch on 8/18/20.
//

import SwiftUI
import CoreData

// Cards core data model
class CardModel: ObservableObject {
    // Core data variables
    let context = persistentContainer.viewContext
    @Published var data: [NSManagedObject] = []
    
    // Model variables
    @Published var company = "norway"
    @Published var number = "0000-0000-0000"
    @Published var gradient = 0
    @Published var name = "trevor"
    @Published var id = UUID()

    
    init() {
        // Read the data when initialized
        readData()
    }
    
    // An initializer with all the variables needed
    init(company: String, number: String, gradient: Int, name: String, id: UUID) {
        self.company = company
        self.number = number
        self.id = id
        self.name = name
        self.gradient = gradient
    }
    
    // Read data from core data
    func readData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CreditCard")
        
        do {
            let results = try context.fetch(request)
            self.data = results as! [NSManagedObject]
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    // Creating a new card
    func writeData() {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "CreditCard", into: persistentContainer.viewContext)
                
        entity.setValue(id, forKey: "id")
        entity.setValue(company, forKey: "company")
        entity.setValue(gradient, forKey: "gradient")
        entity.setValue(name, forKey: "name")
        entity.setValue(number, forKey: "number")
        
        do {
            try context.save()
            
            self.data.append(entity)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    // Deleting a card from core data
    func deleteData(id: UUID) {
        readData()
        
        for card in data {
            if getValue(obj: card).id == id {
                do {
                    let index = data.firstIndex(of: card)!
                    data.remove(at: index)
                    
                    context.delete(card)
                    try context.save()
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
        readData()
    }
    
    func resetData() {
        self.company = ""
        self.number = ""
        self.name = ""
        self.gradient = 0
    }
    
    // Converting from core data to card
    func getValue(obj: NSManagedObject) -> CardModel {
        return CardModel(company: obj.value(forKey: "company") as? String ?? "", number: obj.value(forKey: "number") as? String ?? "", gradient: obj.value(forKey: "gradient") as? Int ?? 0, name: obj.value(forKey: "name") as? String ?? "", id: obj.value(forKey: "id") as? UUID ?? UUID())
    }
}
