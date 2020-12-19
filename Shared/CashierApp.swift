//
//  CashierApp.swift
//  Shared
//
//  Created by Trevor Piltch on 12/19/20.
//

import SwiftUI

@main
struct CashierApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
