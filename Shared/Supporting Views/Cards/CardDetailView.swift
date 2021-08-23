//
//  CardDetailView.swift
//  Cashier
//
//  Created by Trevor Piltch on 2/8/21.
//

import SwiftUI

struct CardDetailView: View {
    var namespace: Namespace.ID
    
    @ObservedObject var cardModel: CardModel
    @ObservedObject var expenseModel: ExpenseModel
    
    @Binding var index: Int
    @Binding var showCardDetail: Bool
    
    @State var deleteCard = false
    @State var showEditCard = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showCardDetail = false
                }) {
                    Text("Done")
                }
                
                if cardModel.getValue(obj: cardModel.data[index]).company != "Cash" {
                     Button(action: {
                         cardModel.selectedObject = [cardModel.data[index]]
                         showEditCard = true
                     }) {
                         Text("Edit")
                     }
                 }
                
                Spacer()
            }
            .padding()
            
            CardItem(card: cardModel.getValue(obj: cardModel.data[index]))
                .matchedGeometryEffect(id: cardModel.getValue(obj: cardModel.data[index]).id, in: namespace)
                .animation(.spring(response: 0.6, dampingFraction: 0.9, blendDuration: 0))
                .frame(width: screen.width - 32, height: 217)
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(expenseModel.data.filter {
                    expenseModel.getValue(obj: $0).selectedCard == "\(cardModel.getValue(obj: cardModel.data[index]).company): \(cardModel.getValue(obj: cardModel.data[index]).number)"
                }, id: \.self) { data in
                    ExpenseRow(expenseModel: expenseModel.getValue(obj: data))
                }
            }
            .padding(.top)
            
            if cardModel.getValue(obj: cardModel.data[index]).company != "Cash" {
                Button(action: {
                    deleteCard = true
                }) {
                    Text("Delete")
                        .foregroundColor(.white)
                        .frame(width: screen.width - 32, height: 44)
                        .background(Color.red)
                        .cornerRadius(11)
                        .padding(.bottom)
                }
            }
            
            
            Spacer()
        }
        .background(Color("Background"))
        .actionSheet(isPresented: $deleteCard) {
            ActionSheet(title: Text("Are you sure you want to delete this card? This action cannot be undone"), buttons:
                            [.destructive(Text("Delete"), action: {
                cardModel.deleteData(id: cardModel.getValue(obj: cardModel.data[index]).id)
                index -= 1
                showCardDetail = false
            }),.cancel()])
        }
        .sheet(isPresented: $showEditCard) {
            CardEditView(newCard: cardModel, gradientNumber: cardModel.getValue(obj: cardModel.data[index]).gradient, cardProvider: cardModel.getValue(obj: cardModel.data[index]).company, cardNumber: cardModel.getValue(obj: cardModel.data[index]).number, name: cardModel.getValue(obj: cardModel.data[index]).name)
        }
    }
    
}

struct CardDetailView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        CardDetailView(namespace: namespace, cardModel: CardModel(company: "norway", number: "1234", gradient: 1, name: "Trevor Piltch", id: UUID()), expenseModel: ExpenseModel(), index: .constant(0), showCardDetail: .constant(true))
    }
}
