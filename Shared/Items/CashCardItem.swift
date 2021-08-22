//
//  CashCardItem.swift
//  Cashier
//
//  Created by Trevor Piltch on 3/16/21.
//

import SwiftUI

struct CashCardItem: View {
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
                Text("Cash")
                    .font(.largeTitle)
            }
        }
        .font(.title2)
        .foregroundColor(.white)
        .frame(width: screen.width - 32, height: 217)
        .background(Color.green)
        .cornerRadius(21)
        .shadow(color: Color.green.opacity(0.2) , radius: 10, x: 0, y: 10)
    }
}

struct CashCardItem_Previews: PreviewProvider {
    static var previews: some View {
        CashCardItem()
    }
}
