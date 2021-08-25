//
//  AddExpenseView.swift
//  Cashier
//
//  Created by Trevor Piltch on 2/1/21.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var itemModel: ExpenseModel
    @ObservedObject var cardModel: CardModel
    @ObservedObject var tagModel: TagModel
    
    @StateObject var keyboard = Keyboard()
    
    @State var selectedCard = CardModel()
    @State var date = Date()
    @State var amount = ""
    @State var item = ""
    @State var tags: [String]? = []
    
    @State var addFailed = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20) {
                List {
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
                            .keyboardType(.decimalPad)
                    }
                    
                    HStack {
                        RoundedRectImageItem(imageName: "tag.circle.fill", color: .orange, size: 36)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                               AddTagItem(tagModel: tagModel)
                                
                                ForEach(tagModel.data, id: \.self) { data in
                                    TagItem(tagModel: tagModel.getValue(obj: data), isSelected: tags!.contains(tagModel.getValue(obj: data).name), tags: $tags)
                                }
                            }
                        }
                    }
                }
                
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Add Expense")
            .navigationBarItems(leading: Button(action: {
                itemModel.resetData()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
            }, trailing: Button(action: {
                if let itemAmount = Double(amount) {
                    itemModel.amount = itemAmount

                    itemModel.date = date
                    itemModel.item = item
                    itemModel.id = UUID()
                    itemModel.selectedCard = "\(selectedCard.company): \(selectedCard.number)"
                    itemModel.type = "Expense"
                    itemModel.tags = tags!

                    itemModel.writeData()
                    itemModel.resetData()

                    self.presentationMode.wrappedValue.dismiss()
                    addFailed = false
                }
                else {
                    addFailed = true
                }
                
            }) {
                Text("Add")
            }
                                    .disabled(item == "" || amount == "" ? true : false)
            )
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            presentationMode.wrappedValue.dismiss()
        }
        .keyboardAdaptive()
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView(itemModel: ExpenseModel(), cardModel: CardModel(company: "Master", number: "0000-0000-0000", gradient: 2, name: "Trevor", id: UUID()), tagModel: TagModel(name: "Test", id: UUID()))
    }
}
