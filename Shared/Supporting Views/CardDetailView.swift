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
    
    @Binding var index: Int
    @Binding var showCarDetail: Bool
    
    @State var deleteCard = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    //Credit card expenses...
                }
                
                
                Button(action: {
                    deleteCard = true
                }) {
                    Text("Delete Card")
                        .frame(width: screen.width - 48, height: 44)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 40)
                .background(Color("Background"))
            }
            .padding(.top, 230)
            
            if cardModel.data.count != 0 {
                CardItem(card: cardModel.getValue(obj: cardModel.data[index]))
                    .scaleEffect(x: 1.1)
                    .matchedGeometryEffect(id: cardModel.getValue(obj: cardModel.data[index]).id, in: namespace)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0))
            }
            
            HStack {
                Spacer()
                
                Button(action: {
                    showCarDetail = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.black)
                        .frame(width: 52, height: 52)
                        .font(.largeTitle)
                        .padding(9)
                        .opacity(0.7)
                }
            }
            .padding()
        }
        .statusBar(hidden: true)
        .background(Color("Background"))
        .ignoresSafeArea()
        .actionSheet(isPresented: $deleteCard) {
            ActionSheet(title: Text("Are you sure you want to delete this card? This action cannot be undone"), buttons:
                [.destructive(Text("Delete"), action: {
                    showCarDetail = false
                    cardModel.deleteData(id: cardModel.getValue(obj: cardModel.data[index]).id)
                }),.cancel()])
        }
    }
    
}

struct CardDetailView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        CardDetailView(namespace: namespace, cardModel: CardModel(), index: .constant(0), showCarDetail: .constant(true))
    }
}
