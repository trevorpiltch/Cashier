//
//  CardsView.swift
//  Cashier
//
//  Created by Trevor Piltch on 12/20/20.
//

import SwiftUI

struct CardsView: View {
    @ObservedObject var cardModel: CardModel
    @Binding var showCardDetail: Bool
    @Binding var index: Int
    
    @State var showAddCard = false
    
    var namespace: Namespace.ID
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    if (cardModel.data.count == 0) {
                        CashCardItem()
                    }
                    else {
                        ForEach(cardModel.data.indices, id: \.self) { i in
                            CardItem(card: cardModel.getValue(obj: cardModel.data[i]))
                                .matchedGeometryEffect(id: cardModel.getValue(obj: cardModel.data[i]).id, in: namespace, isSource: !showCardDetail)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0))
                                .onTapGesture {
                                    index = i
                                    showCardDetail = true
                                }
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .sheet(isPresented: $showAddCard) {
                    AddCardView(newCard: cardModel)
                }
                .navigationTitle("Cards")
                .navigationBarItems(trailing:
                                        Button(action: {
                                            showAddCard = true
                                        }) {
                                            Image(systemName: "plus.circle")
                                        })
            }
        }
    }
}

struct CardsView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        CardsView(cardModel: CardModel(), showCardDetail: .constant(false), index: .constant(0), showAddCard: false, namespace: namespace)
        
    }
}
