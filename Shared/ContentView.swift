//
//  ContentView.swift
//  Shared
//
//  Created by Trevor Piltch on 12/19/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    #endif
   
    @ObservedObject var expenseModel: ItemModel
    @ObservedObject var cardModel: CardModel
    
    var body: some View {
        #if os(iOS)
        if horizontalSizeClass == .compact {
            TabBar(expenseModel: ItemModel(), cardModel: cardModel)
        }
        else {
            SideBar()
        }
        #else
        SideBar()
        #endif
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
        ContentView(expenseModel: ItemModel(), cardModel: CardModel())
    }
}
