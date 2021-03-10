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
    @State var cardNumber = ""
    @State var name = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                cardView
                
                Text("Select a style")
                    .font(.title2)
                    .bold()
                
                HStack(spacing: 20) {
                    ForEach(0..<gradients.count) { i in
                        gradients[i]
                            .frame(width: 52, height: 52)
                            .cornerRadius(40)
                            .opacity(gradientNumber == i ? 1 : 0.4)
                            .onTapGesture {
                                self.gradientNumber = i
                            }
                    }
                    
                    Spacer()
                }
                
                Text("Card Provider")
                    .font(.title2)
                    .bold()
                
                HStack(spacing: 50) {
                    Image("norway")
                        .scaleEffect(0.4)
                        .frame(width: 52, height: 52)
                        .opacity(cardProvider == "norway" ? 1 : 0.4)
                        .onTapGesture {
                            self.cardProvider = "norway"
                        }
                    
                    Image("master")
                        .scaleEffect(0.2)
                        .frame(width: 52, height: 52)
                        .opacity(cardProvider == "master" ? 1 : 0.4)
                        .onTapGesture {
                            self.cardProvider = "master"
                        }
                    
                    Image("visa")
                        .scaleEffect(0.2)
                        .frame(width: 52, height: 52)
                        .opacity(cardProvider == "visa" ? 1 : 0.4)
                        .onTapGesture {
                            self.cardProvider = "visa"
                        }
                }
                
                Text("Card Number")
                    .font(.title2)
                    .bold()
                
                TextField("0000-0000-0000", text: $cardNumber)
                    .keyboardType(.numberPad)
                    .font(.system(size: 24))
                
                Spacer()
            }
            .padding()
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
        .offset(y: -keyboard.currentHeight * 0.9)
        .onTapGesture {
            hideKeyboard()
        }
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
                
                
                Text("\(cardNumber)")
                
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
