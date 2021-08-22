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
class ExpenseModel: ObservableObject, Identifiable {
    // Core data variables
    let context = persistentContainer.viewContext
    @Published var data: [NSManagedObject] = []
    
    // Model Variables
    @Published var date: Date = Date()
    @Published var item: String = ""
    @Published var amount: Double = 0.00
    @Published var selectedCard: String = ""
    @Published var id: UUID = UUID()
    @Published var tags: [String] = []
    @Published var type: String = ""
    @Published var selectedObj: [NSManagedObject] = []
    
    // Other variables
    @Published var total = 0.00
    @Published var first5: [ExpenseModel] = []
    @Published var timeSortedData: [NSManagedObject] = []
    var time = "Month"
    
    let objectWillChange: ObservableObjectPublisher = ObservableObjectPublisher() // To send the alert when something changes
    
    init() {
        // Read the data when initialized
        readData()
    }
    
    // An initializer with all the variables needed
    init(date: Date, item: String, amount: Double, selectedCard: String, tags: [String], type: String, id: UUID) {
        self.date = date
        self.item = item
        self.amount = amount
        self.selectedCard = selectedCard
        self.tags = tags
        self.type = type
        self.id = id
    }
    
    // Read the data from core data
    func readData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
        
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
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: context)
        
        for i in tags {
            print("Tag: \(i)")
        }
                
        entity.setValue(date, forKey: "date")
        entity.setValue(item, forKey: "item")
        entity.setValue(amount, forKey: "amount")
        entity.setValue(selectedCard, forKey: "selectedCard")
        entity.setValue(id, forKey: "id")
        entity.setValue(tags as [NSString], forKey: "tags")
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
        let index = data.firstIndex(of: selectedObj[0])!
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
        
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
            obj?.setValue(tags, forKey: "tags")
            obj?.setValue(type, forKey: "type")
            
            try context.save()
            
            data[index] = obj!
            
        }
        catch {
            print(error.localizedDescription)
        }
        objectWillChange.send()
        sortData()
    }
    
    // Delete an expense
    func deleteData(id: UUID) {
        print("Delete Called")
        print("ID: \(id)")
        readData()
        
        for expense in data {
            print("Loop Called")
            print("ID: \(getValue(obj: expense).id)")
            print("\(getValue(obj: expense).item): \(getValue(obj: expense).amount)")

            if getValue(obj: expense).id == id {
                print("Match found")
                do {
                    let index = data.firstIndex(of: expense)!
                    data.remove(at: index)

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
    
    // Convert from managed object to expense
    func getValue(obj: NSManagedObject) -> ExpenseModel {
        let date = obj.value(forKey: "date") as? Date ?? Date()
        let item = obj.value(forKey: "item") as? String ?? "Example"
        let amount = obj.value(forKey: "amount") as? Double ?? 0.00
        let selectedCard = obj.value(forKey: "selectedCard") as? String ?? ""
        let tags: [String] = {
            let tagModel = TagModel()
            let coreDataTags = obj.value(forKey: "tags") as? [String] ?? [""]
            var expenseTags: [String] = []
            
            
            for tag in tagModel.data {
                if coreDataTags.contains(tagModel.getValue(obj: tag).name) {
                    expenseTags.append(tagModel.getValue(obj: tag).name)
                }
            }
            
            return expenseTags
        }()
        
        return ExpenseModel(date: date, item: item, amount: amount, selectedCard: selectedCard, tags: tags, type: obj.value(forKey: "type") as? String ?? "Expense", id: obj.value(forKey: "id") as? UUID ?? UUID())
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
            
            for item in data {
                let calendar = Calendar.current
                let today = calendar.startOfDay(for: Date())
               
                let itemDate = calendar.startOfDay(for: getValue(obj: item).date)
                
                let diffInDays = Calendar.current.dateComponents([.day], from: today, to: itemDate).day
                
                if (abs(diffInDays!) < 8) {
                    timeSortedData.append(item)
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
            
        case "Year" :
            timeSortedData.removeAll()
            dateFormatter.dateFormat = "YYYY"
            date = dateFormatter.string(from: Date())
            
            for item in data {
                if dateFormatter.string(from: getValue(obj: item).date) == date {
                    timeSortedData.append(item)
                }
            }
            
        case "All" :
            timeSortedData.removeAll()
            
            for item in data {
                timeSortedData.append(item)
            }
            
        default:
            return
        }
    }
    
    func resetData() {
        self.amount = 0.00
        self.date = Date()
        self.item = ""
        self.selectedCard = ""
        self.id = UUID()
    }
}



