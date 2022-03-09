//
//  ContentView.swift
//  Shared
//
//  Created by Trevor Piltch on 12/19/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //MARK: Variables
    //Passed through models
    @ObservedObject var expenseModel: ExpenseModel
    @ObservedObject var cardModel: CardModel
    @ObservedObject var tagModel: TagModel
    
    //MatchedGeometry variables
    @Namespace var namespace1
    @Namespace var namespace2
    
    //Other variables
    @State var showCardDetail = false
    @State var showCardDetailFromHome = false
    @State var index = 0

    //MARK: Views
    var body: some View {
        ZStack {
            TabView {
                NavigationView {
                    HomeView(expenseModel: expenseModel, cardModel: cardModel, tagModel: tagModel, showCardDetail: $showCardDetailFromHome, index: $index, namespace: namespace2)
                        .navigationTitle("Home")
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                
                NavigationView {
                    CardsView(cardModel: cardModel, expenseModel: expenseModel, showCardDetail: $showCardDetail, index: $index, namespace: namespace1)
                       
                    .navigationTitle("Cards")
                }
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("Cards")
                }
                
                SearchView(expenseModel: expenseModel, cardModel: cardModel, tagModel: tagModel)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                
            }
            
            if showCardDetail || showCardDetailFromHome {
                //If one of the cards has been tapped then show cardDetailView on top of tabbar
                CardDetailView(namespace: showCardDetailFromHome ? namespace2 : namespace1, cardModel: cardModel, expenseModel: expenseModel, index: $index, showCardDetail: showCardDetailFromHome ? $showCardDetailFromHome : $showCardDetail)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(expenseModel: ExpenseModel(), cardModel: CardModel(), tagModel: TagModel())
    }
}
