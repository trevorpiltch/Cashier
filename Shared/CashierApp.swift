//
//  CashierApp.swift
//  Shared
//
//  Created by Trevor Piltch on 12/19/20.
//

import SwiftUI
import LocalAuthentication

@main
struct CashierApp: App {
    @AppStorage("hasOpened") var hasOpened = false
    @AppStorage("LockApp") var lockApp: Bool = false
    @AppStorage("UseFaceID") var useFaceID = false

    @StateObject var cardModel = CardModel()
    @StateObject var expenseModel = ExpenseModel()
    @StateObject var tagModel = TagModel()

    @State var isUnlocked = false
    @State var isInBackground = false
    @State var authenticateApp = false
    
    var body: some Scene {
        WindowGroup {
            if hasOpened {
                ZStack {
                    if isUnlocked || !lockApp {
                        ContentView(expenseModel: ExpenseModel(), cardModel: cardModel, tagModel: tagModel)
                            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                                if useFaceID {
                                    // When the app enters the background lock the app
                                    isUnlocked = false
                                    isInBackground = true
                                }
                            }
                    }
                    else {
                        PasswordView(isUnlocked: $isUnlocked, authenticate: $authenticateApp)
                            .onAppear {
                                if useFaceID && !isInBackground {
                                    authenticate()
                                }
                            }
                            .onChange(of: self.authenticateApp) { newValue in
                                authenticate()
                            }
                    }
                }
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
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Allow 'Cashier' to use Face ID to protect your data"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        isUnlocked = true
                        authenticateApp = false
                    }
                    else {
                        //Error With FaceID
                    }
                }
            }
        }
        else {
            // No Biometrics
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
