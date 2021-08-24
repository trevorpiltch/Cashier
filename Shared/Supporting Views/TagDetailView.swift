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
    
    @State var searchQuery = ""
    
    var body: some View {
        if #available(iOS 15.0, *) {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(expenseModel.data.filter { expenseModel.getValue(obj: $0).tags.contains(tagModel.name)}.filter {
                        if searchQuery != "" {
                            return expenseModel.getValue(obj: $0).item.contains(searchQuery) || "\(expenseModel.getValue(obj: $0).amount)".contains(searchQuery)
                        }
                        return true
                    
                    }, id: \.self) { data in
                        NavigationLink(destination: ExpenseDetailView(expenseModel: expenseModel.getValue(obj: data), masterExpenseModel: expenseModel, cardModel: cardModel, selectedObject: data)) {
                            ExpenseRow(expenseModel: expenseModel.getValue(obj: data))
                        }
                    }
                }
                
                Spacer()
            }
            .navigationTitle(tagModel.name)
//            .searchable(text: $searchQuery)
        }
        else {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(expenseModel.data.filter { expenseModel.getValue(obj: $0).tags.contains(tagModel.name)}.filter {
                        if searchQuery != "" {
                            return expenseModel.getValue(obj: $0).item.contains(searchQuery) || "\(expenseModel.getValue(obj: $0).amount)".contains(searchQuery)
                        }
                        return true
                    
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
}

struct TagDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TagDetailView(expenseModel: ExpenseModel(), cardModel: CardModel(), tagModel: TagModel())
    }
}
