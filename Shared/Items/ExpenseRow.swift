//
//  ItemRow.swift
//  Cashier
//
//  Created by Trevor Piltch on 2/23/21.
//

import SwiftUI

struct ExpenseRow: View {
    @ObservedObject var expenseModel: ExpenseModel

    var body: some View {
        HStack {
            RoundedRectImageItem(imageName: "cart.circle.fill", color: .accentColor, size: 36)
            
            VStack(alignment: .leading) {
                Text("$\(expenseModel.amount, specifier: "%.2f") - \(expenseModel.item)")
                    .font(.title3)
                    .bold()
                    
                
                Text("\(dateFormatter.string(from: expenseModel.date))")
                    .opacity(0.7)
            }
            .foregroundColor(Color("Text"))
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color.black.opacity(0.7))
        }
        .padding(.horizontal)
    }
}

struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseRow(expenseModel: ExpenseModel(date: Date(), item: "Test", amount: 10.0, selectedCard: "", tags: [""], type: "expense", id: UUID()))
    }
}
