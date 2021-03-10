//
//  ItemRow.swift
//  Cashier
//
//  Created by Trevor Piltch on 2/23/21.
//

import SwiftUI

struct ItemRow: View {
    @ObservedObject var itemModel: ItemModel

    var index: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("$\(itemModel.getValue(obj: itemModel.data[index]).amount, specifier: "%.2f") - \(itemModel.getValue(obj: itemModel.data[index]).item)")
                .font(.title3)
                .foregroundColor(itemModel.getValue(obj: itemModel.data[index]).type.lowercased() == "expense" ? Color.red : Color.green)
            
            Text("\(dateFormatter.string(from: itemModel.getValue(obj: itemModel.data[index]).date))")
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
        ItemRow(itemModel: ItemModel(date: Date(), item: "Test", amount: 10.0, selectedCard: "", tags: [""], type: "expense"), index: 0)
    }
}
