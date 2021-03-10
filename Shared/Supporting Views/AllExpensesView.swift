//
//  AllExpensesView.swift
//  Cashier
//
//  Created by Trevor Piltch on 12/23/20.
//

import SwiftUI

struct AllExpensesView: View {
//    @FetchRequest(sortDescriptors: [],animation: .default)
//
//    private var items: FetchedResults<Expense>
//    let dateFormatter = DateFormatter()
    
    var body: some View {
        VStack {
            Text("Hello world.")
        }
//        List {
//            ForEach(items.sorted { (first, last) -> Bool in
//                first.date! > last.date!
//            }, id: \.id) { item in
//                VStack(alignment: .leading) {
//                    Text("$\(item.amount, specifier: "%.2f") - \(item.item ?? "Empty Item")")
//                        .foregroundColor(.red)
//
//                    Text("\(dateFormatter.string(from: item.date ?? Date()))")
//                        .font(.footnote)
//                        .foregroundColor(.gray)
//                }
//            }
//        }
//        .navigationTitle("All")
//        .onAppear {
//            dateFormatter.dateStyle = .short
//        }
    }
}

struct AllExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        AllExpensesView()
    }
}
