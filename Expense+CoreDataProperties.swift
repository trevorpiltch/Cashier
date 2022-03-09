//
//  Expense+CoreDataProperties.swift
//  Cashier
//
//  Created by Trevor Piltch on 8/14/21.
//
//

import Foundation
import CoreData


extension Expense {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var item: String?
    @NSManaged public var selectedCard: String?
    @NSManaged public var type: String?
    @NSManaged public var tags: [NSString]?
}
