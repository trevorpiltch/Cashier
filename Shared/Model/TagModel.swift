//
//  TagModel.swift
//  Cashier (iOS)
//
//  Created by Trevor Piltch on 8/14/21.
//

import SwiftUI
import CoreData


class TagModel: ObservableObject, Identifiable {
    // CoreData Variables
    let context = persistentContainer.viewContext
    @Published var data: [NSManagedObject] = []
    
    // Model Variables
    @Published var name: String = ""
    @Published var id: UUID = UUID()
    
    init() {
        readData()
    }
    
    init(name: String, id: UUID) {
        self.name = name
        self.id = id
    }
    
    func readData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tags")
        
        do {
            let results = try context.fetch(request)
            self.data = results as! [NSManagedObject]
            
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func writeData() {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Tags", into: context)
        
        entity.setValue(name, forKey: "name")
        entity.setValue(id, forKey: "id")
        
        do {
            try context.save()
            self.data.append(entity)
        }
        catch {
            print(error.localizedDescription)
        }
        
        resetData()
    }
    
    func deleteData(id: UUID) {
        readData()
        for tag in data {
            if getValue(obj: tag).id == id {
                do {
                    let index = data.firstIndex(of: tag)!
                    data.remove(at: index)
                    
                    context.delete(tag)
                    try context.save()
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getValue(obj: NSManagedObject) -> TagModel {
        return TagModel(name: obj.value(forKey: "name") as? String ?? "", id: obj.value(forKey: "id") as? UUID ?? UUID())
    }
    
    func resetData() {
        name = ""
        id = UUID()
    }
}
