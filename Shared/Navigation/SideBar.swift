//
//  SideBar.swift
//  Cashier
//
//  Created by Trevor Piltch on 12/20/20.
//

import SwiftUI

struct SideBar: View {
    var body: some View {
        NavigationView {
            List {
//                NavigationLink(destination: DashboardView()) {
//                    Label("Dashboard", systemImage: "gauge")
//                }
//                NavigationLink(destination: AllExpensesView()) {
//                    Label("Expenses", systemImage: "cart")
//                }
//                NavigationLink(destination: CardsView()) {
//                    Label("Cards", systemImage: "creditcard")
//                }
            }
            .navigationTitle(Text("Cashier"))
            .listStyle(SidebarListStyle())
        }
        
        
    }
}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBar()
    }
}
