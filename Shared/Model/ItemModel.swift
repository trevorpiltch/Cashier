//
//  Expense.swift
//  Cashier
//
//  Created by Trevor Piltch on 8/18/20.
//

import SwiftUI
import CoreData
import Combine

func saveContext() {
    let context = persistentContainer.viewContext
    
    if context.hasChanges {
        do {
            try context.save()
        }
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

// Expense Core Data Model
class ItemModel: ObservableObject, Identifiable {
    // Core data variables
    let context = persistentContainer.viewContext
    @Published var data: [NSManagedObject] = []
    
    // Model Variables
    @Published var date: Date = Date()
    @Published var item: String = ""
    @Published var amount: Double = 0.00
    @Published var selectedCard: String = ""
    @Published var id: UUID = UUID()
//    @Published var tags: [String] = [""]
    @Published var type: String = ""
    @Published var selectedObj: [NSManagedObject] = []
    
    // Other variables
    @Published var total = 0.00
    @Published var first5: [ItemModel] = []
    @Published var timeSortedData: [NSManagedObject] = []
    var time = "Month"
    
    let objectWillChange: ObservableObjectPublisher = ObservableObjectPublisher() // To send the alert when something changes
    
    init() {
        // Read the data when initialized
        readData()
    }
    
    // An initializer with all the variables needed
    init(date: Date, item: String, amount: Double, selectedCard: String, tags: [String], type: String) {
        self.date = date
        self.item = item
        self.amount = amount
        self.selectedCard = selectedCard
//        self.tags = tags
        self.type = type
    }
    
    // Read the data from core data
    func readData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        
        do {
            let results = try context.fetch(request)
            self.data = results as! [NSManagedObject]
            self.data.sort { (expense1, expense2) -> Bool in
                return getValue(obj: expense1).date > getValue(obj: expense2).date
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
        objectWillChange.send()
        sortData()
    }
    
    // Create a new expense
    func writeData() {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context)
                
        entity.setValue(date, forKey: "date")
        entity.setValue(item, forKey: "item")
        entity.setValue(amount, forKey: "amount")
        entity.setValue(selectedCard, forKey: "selectedCard")
        entity.setValue(id, forKey: "id")
//        entity.setValue(tags, forKey: "tags")
        entity.setValue(type, forKey: "type")
        
        do {
            try context.save()
            
            self.data.append(entity)
            // Sort the data by the date
            self.data.sort { (expense1, expense2) -> Bool in
                return getValue(obj: expense1).date > getValue(obj: expense2).date
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
        readData()
        objectWillChange.send()
        sortData()
    }
    
    // Update the data (changes in expense detail view
    func updateData() {
        let index = data.firstIndex(of: selectedObj[0])
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        
        do {
            let results = try context.fetch(request) as! [NSManagedObject]
            
            let obj = results.first { (obj) -> Bool in
                if obj == selectedObj[0] {
                    return true
                }
                else {
                    return false
                }
            }
            
            obj?.setValue(date, forKey: "date")
            obj?.setValue(item, forKey: "item")
            obj?.setValue(amount, forKey: "amount")
            obj?.setValue(selectedCard, forKey: "selectedCard")
            obj?.setValue(id, forKey: "id")
//            obj?.setValue(tags, forKey: "tags")
            obj?.setValue(type, forKey: "type")
            
            try context.save()
            
            data[index!] = obj!
            
        }
        catch {
            print(error.localizedDescription)
        }
        objectWillChange.send()
        sortData()
    }
    
    // Delete an expense
    func deleteData(index: Int) {
        readData()
        
        for i in data.indices {
            if i == index {
                do {
                    let expense = data[i]
                    data.remove(at: i)
                    
                    context.delete(expense)
                    try context.save()
                    print("Deleting Expense")

                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        readData()
        objectWillChange.send()
        sortData()
    }
    
    // Convert from manageed object to expense
    func getValue(obj: NSManagedObject) -> ItemModel {
        return ItemModel(date: obj.value(forKey: "date") as? Date ?? Date(), item: obj.value(forKey: "item") as? String ?? "Example", amount: obj.value(forKey: "amount") as? Double ?? 0.00, selectedCard: obj.value(forKey: "id") as? String ?? "", tags: [""], type: obj.value(forKey: "type") as? String ?? "Expense")
    }
    
    // Calculate the total for all the expenses
    func calculateTotal() -> Double {
        total = 0
        
        for expense in timeSortedData {
            total += getValue(obj: expense).amount
        }
        
        return total
    }
    
    func sortData() {
        var date = ""
        let dateFormatter = DateFormatter()
        
        switch(time) {
        case "Week":
            timeSortedData.removeAll()
            dateFormatter.dateFormat = "EEE"
            
            for item in data {
                switch(dateFormatter.string(from: getValue(obj: item).date)) {
                case "Sun": print("")
                case "Mon":
                case "Tue":
                case "Wed":
                case "Thu":
                case "Fri":
                case "Sat":
                default:
                    print("Error: Something went wrong")
                }
            }
            
        case "Month" :
            timeSortedData.removeAll()
            dateFormatter.dateFormat = "MM"
            date = dateFormatter.string(from: Date())
            
            for item in data {
                if dateFormatter.string(from: getValue(obj: item).date) == date {
                    timeSortedData.append(item)
                }
            }
            
            print("Month")
            
        case "Year" :
            timeSortedData.removeAll()
            dateFormatter.dateFormat = "YYYY"
            date = dateFormatter.string(from: Date())
            
            for item in data {
                if dateFormatter.string(from: getValue(obj: item).date) == date {
                    timeSortedData.append(item)
                }
            }
            print("Year")
            
        case "All" :
            timeSortedData.removeAll()
            
            for item in data {
                timeSortedData.append(item)
            }
            
            print("All")
            
        default:
            return
        }
    }
}

// Date formatter
let dateFormatter: DateFormatter = DateFormatter()

