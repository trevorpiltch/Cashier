//
//  AddItemView.swift
//  Cashier
//
//  Created by Trevor Piltch on 2/22/21.
//

import SwiftUI

struct AddItemView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello")
                
                Spacer()
            }
            .navigationTitle("Add Expense")
            .navigationBarItems(leading: Button(action: {
                
            }) {
                Text("Cancel")
            }, trailing: Button(action: {
                
            }) {
                Text("Add")
            })
        
        }
    
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
