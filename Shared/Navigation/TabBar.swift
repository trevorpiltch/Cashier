//
//  TabBar.swift
//  Cashier
//
//  Created by Trevor Piltch on 12/20/20.
//

import SwiftUI

struct TabBar: View {
    @ObservedObject var expenseModel: ItemModel
    @ObservedObject var cardModel: CardModel
    
    @State var showCardDetail = false
    @State var index = 0
    
    @Namespace var namespace
    
    
    var body: some View {
        ZStack {
            TabView {
                HomeView(itemModel: expenseModel, cardModel: cardModel)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                
                CardsView(cardModel: cardModel, showCardDetail: $showCardDetail, index: $index, namespace: namespace)
                    .tabItem {
                        Image(systemName: "creditcard")
                        Text("Cards")
                    }
                
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
            }
            
            if showCardDetail {
                CardDetailView(namespace: namespace, cardModel: cardModel, index: $index, showCarDetail: $showCardDetail)
            }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(expenseModel: ItemModel(), cardModel: CardModel())
    }
}
