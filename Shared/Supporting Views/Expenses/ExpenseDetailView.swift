//
//  ExpenseDetailView.swift
//  Cashier (iOS)
//
//  Created by Trevor Piltch on 8/15/21.
//

import SwiftUI
import CoreData

struct ExpenseDetailView: View {
    @ObservedObject var expenseModel: ExpenseModel
    @ObservedObject var masterExpenseModel: ExpenseModel
    @ObservedObject var cardModel: CardModel
    
    @State var deleteExpense = false
    @State var editExpense = false
    
    var selectedObject: NSManagedObject? = nil
    
    var body: some View {
        List {
            ForEach(cardModel.data.indices, id: \.self) { index in
                if "\(cardModel.getValue(obj: cardModel.data[index]).company): \(cardModel.getValue(obj: cardModel.data[index]).number)" == expenseModel.selectedCard {
                    CardItem(card: cardModel.getValue(obj: cardModel.data[index]))
                        .scaleEffect(0.8)
                        .offset(x: -22, y: 0)
                }
            }
            
            HStack {
                RoundedRectImageItem(imageName: "calendar.circle.fill", color: .red, size: 36)
                
                Text("Date:")
                    .bold()
                
                Text(dateFormatter.string(from: expenseModel.date))
            }
            
            HStack {
                RoundedRectImageItem(imageName: "bag.circle.fill", color: .blue, size: 36)
                
                Text("Item:")
                    .bold()
                
                Text(expenseModel.item)
            }
            
            HStack {
                RoundedRectImageItem(imageName: "dollarsign.circle.fill", color: .green, size: 36)
                
                Text("Amount:")
                    .bold()
                
                Text("\(expenseModel.amount, specifier: "%.2f")")
            }
            
            HStack {
                RoundedRectImageItem(imageName: "tag.circle.fill", color: .orange, size: 36)
                
                Text("Tags:")
                    .bold()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(expenseModel.tags, id: \.self) { name in
                            TagItem(tagModel: TagModel(name: name, id: UUID()), isSelected: true, tags: .constant(nil))
                        }
                    }
                }
            }
            .onTapGesture {
                for i in expenseModel.tags {
                    print(i)
                }
            }
        }
        .navigationTitle(expenseModel.item)
        .navigationBarItems(trailing:
                                Button(action: {
            masterExpenseModel.selectedObj = [selectedObject!]
            editExpense = true
        }) {
            Text("Edit")
        }
                            
        )
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.status) {
                Button(action: {
                    deleteExpense = true
                }) {
                    Text("Delete")
                        .foregroundColor(.white)
                        .frame(width: screen.width - 32, height: 44)
                        .background(Color.red)
                        .cornerRadius(11)
                        .padding(.bottom)
                }
            }
        }
        .actionSheet(isPresented: $deleteExpense ) {
            ActionSheet(title: Text("Are you sure you want to delete this expense? This action cannot be undone"), buttons:
                [
                    .destructive(
                        Text("Delete"), action: { print("Delete?"); masterExpenseModel.deleteData(id: expenseModel.id) }
                    ),
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $editExpense) {
            EditExpenseView(itemModel: expenseModel, masterExpenseModel: masterExpenseModel, cardModel: cardModel, tagModel: TagModel(), selectedCard: cardModel.getValue(obj: cardModel.data.first(where: { data in
                "\(cardModel.getValue(obj: data).company): \(cardModel.getValue(obj: data).number)" == expenseModel.selectedCard
            })!), date: expenseModel.date, amount: "\(expenseModel.amount)", item: expenseModel.item, tags: expenseModel.tags, addFailed: false)
        }
    }
}

struct ExpenseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseDetailView(expenseModel: ExpenseModel(date: Date(), item: "Detail Test", amount: 20.00, selectedCard: "norway: 1234", tags: ["test"], type: "", id: UUID()), masterExpenseModel: ExpenseModel(), cardModel: CardModel(company: "norway", number: "1234", gradient: 1, name: "", id: UUID()))
    }
}
