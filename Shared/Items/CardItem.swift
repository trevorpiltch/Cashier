//
//  CardItem.swift
//  Cashier
//
//  Created by Trevor Piltch on 1/2/21.
//

import SwiftUI

struct CardItem: View {
    var card: CardModel
    
    var body: some View {
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
                    Image(card.company)
                        .scaleEffect(card.company == "norway" ? 0.3 : 0.2)
                        .frame(width: 20, height: 20)
                        .padding(20)
                    
                    Spacer()
                }
                .padding(16)
                
                
                Text("\(card.number)")
                
                Spacer()
                
                HStack {
                    Text(card.name.uppercased())
                        .font(.title3)
                    
                    Spacer()
                    
                    Text(card.company.uppercased())
                }
                .padding(16)
            }
            
        }
        .font(.title2)
        .foregroundColor(card.gradient < 3 ? Color.white : Color.black)
        .frame(width: screen.width - 32, height: 217)
        .background(gradients[Int(card.gradient)])
        .cornerRadius(21)
        .shadow(color: gradientColors[Int(card.gradient)].opacity(0.2) , radius: 10, x: 0, y: 10)
    }
}

struct CardItem_Previews: PreviewProvider {
    static var previews: some View {
        CardItem(card: CardModel())
    }
}