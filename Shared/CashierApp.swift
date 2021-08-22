//
//  CashierApp.swift
//  Shared
//
//  Created by Trevor Piltch on 12/19/20.
//

import SwiftUI

@main
struct CashierApp: App {
    @AppStorage("hasOpened") var hasOpened = false

    @StateObject var cardModel = CardModel()
    @StateObject var expenseModel = ExpenseModel()
    @StateObject var tagModel = TagModel()

    var body: some Scene {
        WindowGroup {
            if hasOpened {
                ContentView(expenseModel: ExpenseModel(), cardModel: cardModel, tagModel: tagModel)
            }
            else {
                OnBoardingView()
                    .onAppear {
                        cardModel.company = "Cash"
                        cardModel.writeData()
                        cardModel.resetData()
                    }
            }
        }
        
    }
}

// Date formatter
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/YYYY"
    return formatter
}()

let screen = UIScreen.main.bounds

let gradients: [LinearGradient] = [
    LinearGradient(gradient: Gradient(colors: [Color("Blue1"), Color("Purple1")]), startPoint: .leading, endPoint: .topTrailing),
    LinearGradient(gradient: Gradient(colors: [Color("Green1"), Color("Blue2")]), startPoint: .leading, endPoint: .topTrailing),
    LinearGradient(gradient: Gradient(colors: [Color("Blue1"), Color("Purple2")]), startPoint: .leading, endPoint: .topTrailing),
    LinearGradient(gradient: Gradient(colors: [Color("Orange1"), Color("Yellow1")]), startPoint: .leading, endPoint: .topTrailing),
    LinearGradient(gradient: Gradient(colors: [Color("Green3"), Color("Yellow2")]), startPoint: .leading, endPoint: .topTrailing),
]

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
