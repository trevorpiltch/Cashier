//
//  ItemRow.swift
//  Cashier
//
//  Created by Trevor Piltch on 2/23/21.
//

import SwiftUI

struct ExpenseRow: View {
    @ObservedObject var expenseModel: ExpenseModel

    var index: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("$\(expenseModel.getValue(obj: expenseModel.data[index]).amount, specifier: "%.2f") - \(expenseModel.getValue(obj: expenseModel.data[index]).item)")
                .font(.title3)
                .foregroundColor(expenseModel.getValue(obj: expenseModel.data[index]).type.lowercased() == "expense" ? Color.red : Color.green)
            
            Text("\(dateFormatter.string(from: expenseModel.getValue(obj: expenseModel.data[index]).date))")
                .opacity(0.7)
            
            Divider()
        }
        
        .padding(.horizontal)
        .padding(.vertical, 5)
        .onAppear {
            dateFormatter.dateFormat = "MM/dd/YYYY"
        }
    }
}

struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseRow(expenseModel: ExpenseModel(date: Date(), item: "Test", amount: 10.0, selectedCard: "", tags: [""], type: "expense"), index: 0)
    }
}
