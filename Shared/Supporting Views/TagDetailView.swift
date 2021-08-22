//
//  TagDetailView.swift
//  Cashier (iOS)
//
//  Created by Trevor Piltch on 8/22/21.
//

import SwiftUI

struct TagDetailView: View {
    @ObservedObject var expenseModel: ExpenseModel
    @ObservedObject var cardModel: CardModel
    @ObservedObject var tagModel: TagModel
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Hi")
            }
            .navigationTitle(tagModel.name)
        }
    }
}

struct TagDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TagDetailView(expenseModel: ExpenseModel(), cardModel: CardModel(), tagModel: TagModel())
    }
}
