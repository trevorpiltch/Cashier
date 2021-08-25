//
//  AddCardView.swift
//  Cashier
//
//  Created by Trevor Piltch on 2/5/21.
//

import SwiftUI

struct AddCardView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var newCard: CardModel
    
    @StateObject var keyboard = Keyboard()
    
    @State var gradientNumber = 0
    @State var cardProvider = ""
    @State var cardNumber: String = ""
    @State var name = ""
    
    var body: some View {
        NavigationView {
            List {
                cardView
                    .scaleEffect(0.9)
                    .offset(x: -20, y: 0)
                
                HStack {
                    RoundedRectImageItem(imageName: "pencil.circle.fill", color: .green, size: 36)
                    
                    Text("Select a style")
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(0..<gradients.count) { i in
                                gradients[i]
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(40)
                                    .opacity(gradientNumber == i ? 1 : 0.4)
                                    .onTapGesture {
                                        self.gradientNumber = i
                                    }
                            }
                            
                            Spacer()
                        }
                    }
                }
                
                HStack {
                    RoundedRectImageItem(imageName: "creditcard.circle.fill", color: .blue, size: 36)
                    
                    Text("Card Provider")
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 40) {
                            Image("norway")
                                .scaleEffect(0.28)
                                .frame(width: 36, height: 36)
                                .opacity(cardProvider == "norway" ? 1 : 0.4)
                                .onTapGesture {
                                    self.cardProvider = "norway"
                                }
                            
                            Image("master")
                                .scaleEffect(0.17)
                                .frame(width: 44, height: 44)
                                .opacity(cardProvider == "master" ? 1 : 0.4)
                                .onTapGesture {
                                    self.cardProvider = "master"
                                }
                            
                            Image("visa")
                                .scaleEffect(0.2)
                                .frame(width: 44, height: 44)
                                .opacity(cardProvider == "visa" ? 1 : 0.4)
                                .onTapGesture {
                                    self.cardProvider = "visa"
                                }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                HStack {
                    RoundedRectImageItem(imageName: "lock.circle.fill", color: .purple, size: 36)
                    
                    Text("Card Number")
                    
                    TextField("0000", text: $cardNumber)
                        .keyboardType(.numberPad)
                        .font(.system(size: 24))
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Add Card")
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
                
                newCard.resetData()
            }) {
                Text("Cancel")
            }, trailing: Button(action: {
                newCard.company = cardProvider
                newCard.number = cardNumber
                newCard.name = name
                newCard.gradient = gradientNumber
                newCard.id = UUID()
                
                newCard.writeData()
                
                newCard.resetData()
                
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Add")
                
            }
            .disabled(cardProvider == "" || cardNumber == ""))
            
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            presentationMode.wrappedValue.dismiss()
        }
        .keyboardAdaptive()
    }
    
    var cardView: some View {
        ZStack {
            HStack {
                Image("Vector2")
                    .rotationEffect(.degrees(90))
                    .scaleEffect(1.1)
                    .offset(x: -60)
                
                Spacer()
                
                Image("Vector")
                    .scaleEffect(2)
                    .offset(x: 40)
            }
            
            VStack {
                HStack {
                    Image(cardProvider)
                        .scaleEffect(cardProvider == "norway" ? 0.3 : 0.2)
                        .frame(width: 20, height: 20)
                        .padding(20)
                    
                    Spacer()
                    
                    Image(systemName: "badge.plus.radiowaves.right")
                }
                .padding(16)
                
                
                Text("XXXX-XXXX-XXXX-\(cardNumber)")
                
                Spacer()
                
                HStack {
                    Text(name.uppercased())
                        .font(.title3)
                    
                    Spacer()
                    
                    Text(cardProvider.uppercased())
                }
                .padding(16)
            }
            
        }
        .font(.title2)
        .foregroundColor(gradientNumber < 3 ? Color.white : Color.black)
        .frame(width: screen.width - 32, height: 217)
        .background(gradients[gradientNumber])
        .cornerRadius(21)
        .shadow(color: gradientColors[gradientNumber].opacity(0.2) , radius: 10, x: 0, y: 10)
        
    }
}


struct AddCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddCardView(newCard: CardModel())
    }
}
