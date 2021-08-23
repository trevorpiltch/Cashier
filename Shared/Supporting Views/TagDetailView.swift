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
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(expenseModel.data.filter {
                    expenseModel.getValue(obj: $0).tags.contains(tagModel.name)
                }, id: \.self) { data in
                    NavigationLink(destination: ExpenseDetailView(expenseModel: expenseModel.getValue(obj: data), masterExpenseModel: expenseModel, cardModel: cardModel, selectedObject: data)) {
                        ExpenseRow(expenseModel: expenseModel.getValue(obj: data))
                    }
                }
            }
            
            Spacer()
        }
        .navigationTitle(tagModel.name)
    }
}

struct TagDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TagDetailView(expenseModel: ExpenseModel(), cardModel: CardModel(), tagModel: TagModel())
    }
}
