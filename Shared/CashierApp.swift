//
//  CashierApp.swift
//  Shared
//
//  Created by Trevor Piltch on 12/19/20.
//

import SwiftUI

@main
struct CashierApp: App {
     //For changing the navigation bar appearence
    init() {
//        let navigationBarAppearance = UINavigationBarAppearance()
//
//        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.accentColor)]
//        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(Color.accentColor)]
//
//        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
//        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        dateFormatter.dateFormat = "MM/dd/YYYY"
    }

    @StateObject var cardModel = CardModel()
    @StateObject var expenseModel = ItemModel()

    var body: some Scene {
        WindowGroup {
            ContentView(expenseModel: ItemModel(), cardModel: cardModel)
        }
    }
}

let gradients: [LinearGradient] = [
    LinearGradient(gradient: Gradient(colors: [Color("Blue1"), Color("Purple1")]), startPoint: .leading, endPoint: .topTrailing),
    LinearGradient(gradient: Gradient(colors: [Color("Green1"), Color("Blue2")]), startPoint: .leading, endPoint: .topTrailing),
    LinearGradient(gradient: Gradient(colors: [Color("Blue1"), Color("Purple2")]), startPoint: .leading, endPoint: .topTrailing),
    LinearGradient(gradient: Gradient(colors: [Color("Orange1"), Color("Yellow1")]), startPoint: .leading, endPoint: .topTrailing),
    LinearGradient(gradient: Gradient(colors: [Color("Green3"), Color("Yellow2")]), startPoint: .leading, endPoint: .topTrailing),
]

let screen = UIScreen.main.bounds

let gradientColors: [Color] = [
    Color("Blue1"),
    Color("Green1"),
    Color("Blue1"),
    Color("Orange1"),
    Color("Green3")
]


extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}
