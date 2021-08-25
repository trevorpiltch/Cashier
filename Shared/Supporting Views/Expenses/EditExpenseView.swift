//
//  EditExpenseView.swift
//  Cashier (iOS)
//
//  Created by Trevor Piltch on 8/20/21.
//

import SwiftUI

struct EditExpenseView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var itemModel: ExpenseModel
    @ObservedObject var masterExpenseModel: ExpenseModel
    @ObservedObject var cardModel: CardModel
    @ObservedObject var tagModel: TagModel
    
    @State var selectedCard = CardModel()
    @State var date = Date()
    @State var amount = ""
    @State var item = ""
    @State var tags: [String]? = []
    
    @State var addFailed = false
    
    var body: some View {
        NavigationView {
            List  {
                TabView {
                    ForEach(cardModel.data.indices, id: \.self) { i in
                        ZStack {
                            CardItem(card: cardModel.getValue(obj: cardModel.data[i]))
                                .onTapGesture {
                                    selectedCard = cardModel.getValue(obj: cardModel.data[i])
                                }

                            Rectangle()
                                .frame(width: screen.width - 32, height: 217)
                                .cornerRadius(20)
                                .foregroundColor(.black)
                                .opacity(selectedCard.id == cardModel.getValue(obj: cardModel.data[i]).id ? 0.6 : 0)
                        }
                        .scaleEffect(0.8)
                        
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.vertical)
                .frame(width: screen.width - 32, height: 217)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .offset(x: -20, y: 0)
                
                
                DatePicker(selection: $date, displayedComponents: DatePickerComponents.date) {
                    RoundedRectImageItem(imageName: "calendar.circle.fill", color: .red, size: 36)
                    
                    Text("Date")
                }
                .datePickerStyle(DefaultDatePickerStyle())
                
                HStack {
                    RoundedRectImageItem(imageName: "bag.circle.fill", color: .blue, size: 36)
                    
                    Text("Item:")
                    
                    Spacer()
                    
                    TextField("Item name", text: $item)
                }
                
                HStack {
                    RoundedRectImageItem(imageName: "dollarsign.circle.fill", color: .green, size: 36)
                    
                    Text("Amount:")
                    
                    Spacer()
                    
                    TextField("0.00", text: $amount)
                        .keyboardType(.numberPad)
                }
                
                HStack {
                    RoundedRectImageItem(imageName: "tag.circle.fill", color: .orange, size: 36)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(tagModel.data, id: \.self) { data in
                                TagItem(tagModel: tagModel.getValue(obj: data), isSelected: tags!.contains(tagModel.getValue(obj: data).name), tags: $tags)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle(item)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
            }, trailing: Button(action: {
                if let itemAmount = Double(amount) {
                    masterExpenseModel.amount = itemAmount
                    
                    masterExpenseModel.date = date
                    masterExpenseModel.item = item
                    masterExpenseModel.selectedCard = "\(selectedCard.company): \(selectedCard.number)"
                    masterExpenseModel.type = "Expense"
                    masterExpenseModel.tags = tags!
                    
                    masterExpenseModel.updateData()
                    masterExpenseModel.resetData()
                    
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Done")
            }
            )
            .keyboardAdaptive()
        }
    }
}

struct EditExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        EditExpenseView(itemModel: ExpenseModel(), masterExpenseModel: ExpenseModel(), cardModel: CardModel(), tagModel: TagModel())
    }
}
