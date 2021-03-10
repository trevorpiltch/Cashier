//
//  AddExpenseView.swift
//  Cashier
//
//  Created by Trevor Piltch on 2/1/21.
//

import SwiftUI

struct AddExpenseView: View {
//    @ObservedObject var itemModel: ItemModel
//    @ObservedObject var cardModel: CardModel
    
//    var isExpense: Bool
    
    @State var date = Date()
    @State var item = ""
    @State var amount = 0.00
    @State var tags = [""]
    
    var body: some View {
        NavigationView {
//            expenseView
////            if isExpense {
////               expenseView
////            }
////            else {
////                incomeView
////            }
            
            VStack {
                TabView {
    //                ForEach(cardModel.data.indices, id: \.self) { i in
    //                    CardItem(card: cardModel.getValue(obj: cardModel.data[i]))
    //                }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                Spacer()
                
    //            HStack {
    //                Image(systemName: "calendar")
    //
    //                DatePicker("Date", selection: $date)
    //            }
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
//    
//    var expenseView: some View {
//     
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView()
    }
}
