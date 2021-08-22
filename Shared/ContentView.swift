//
//  ContentView.swift
//  Shared
//
//  Created by Trevor Piltch on 12/19/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var expenseModel: ExpenseModel
    @ObservedObject var cardModel: CardModel
    @ObservedObject var tagModel: TagModel
    
    @State var showCardDetail = false
    @State var index = 0
    
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            
            TabView {
                NavigationView {
                    HomeView(expenseModel: expenseModel, cardModel: cardModel, tagModel: tagModel)
                           
                        .navigationTitle("Home")
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
            }
                
                NavigationView {
                    CardsView(cardModel: cardModel, expenseModel: expenseModel, showCardDetail: $showCardDetail, index: $index, namespace: namespace)
                       
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
            if showCardDetail {
                CardDetailView(namespace: namespace, cardModel: cardModel, expenseModel: expenseModel, index: $index, showCardDetail: $showCardDetail)
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(expenseModel: ExpenseModel(), cardModel: CardModel(), tagModel: TagModel())
    }
}
