//
//  CashierApp.swift
//  Shared
//
//  Created by Trevor Piltch on 12/19/20.
//
import SwiftUI
import CoreData
import LocalAuthentication

@main
struct CashierApp: App {
    //MARK: Variables
    //App Storage Variables
    @AppStorage("hasOpened") var hasOpened = false
    @AppStorage("LockApp") var lockApp: Bool = false
    @AppStorage("UseFaceID") var useFaceID = false
    
    //Initializing the models
    @StateObject var cardModel = CardModel()
    @StateObject var expenseModel = ExpenseModel()
    @StateObject var tagModel = TagModel()
    
    //Other
    @State var isUnlocked = false
    @State var isInBackground = false
    @State var isAuthenticated = false
    
    //MARK: Views
    var body: some Scene {
        WindowGroup {
            ZStack {
                if hasOpened {
                    //If the user has opened the app before
                    if isUnlocked || !lockApp {
                        //If the user has unlocked the app or the app is not password protected
                        ContentView(expenseModel: ExpenseModel(), cardModel: cardModel, tagModel: tagModel)
                    }
                    else {
                        //If the app is locked
                        PasswordView(isUnlocked: $isUnlocked, authenticate: $isAuthenticated)
                            .onAppear {
                                //When password appears (not in the background) and the user wants faceID then authenticate
                                if useFaceID && !isInBackground {
                                    authenticate()
                                }
                            }
                            .onChange(of: self.isAuthenticated) { newValue in
                                //If the user taps the facaID button then authenticate
                                authenticate()
                            }
                    }
                }
                else {
                    //If it's the first open for the app
                    OnBoardingView(cardModel: cardModel)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                //When the app enters the background lock the app
                if lockApp {
                    isUnlocked = false
                    isInBackground = true
                }
            }
        }
    }
    
    //Function to authenticate the user using bioauthentication
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Allow 'Cashier' to use Face ID to protect your data"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        //Success with authentication and unlock the app
                        isUnlocked = true
                        isAuthenticated = false
                    }
                    else {
                        if let error = authenticationError {
                            //Error with authentication
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
        else {
            //No Biometrics
        }
    }
}

//MARK: Universal Variables

// Variable to format dates
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/YYYY"
    return formatter
}()

//Screen dimensions
let screen = UIScreen.main.bounds

//Gradients for the credit card backgrounds
let gradients: [LinearGradient] = [
    LinearGradient(gradient: Gradient(colors: [Color("Blue1"), Color("Purple1")]), startPoint: .leading, endPoint: .topTrailing),
    LinearGradient(gradient: Gradient(colors: [Color("Green1"), Color("Blue2")]), startPoint: .leading, endPoint: .topTrailing),
    LinearGradient(gradient: Gradient(colors: [Color("Blue1"), Color("Purple2")]), startPoint: .leading, endPoint: .topTrailing),
    LinearGradient(gradient: Gradient(colors: [Color("Orange1"), Color("Yellow1")]), startPoint: .leading, endPoint: .topTrailing),
    LinearGradient(gradient: Gradient(colors: [Color("Green3"), Color("Yellow2")]), startPoint: .leading, endPoint: .topTrailing),
]

//List of possible gradient colors
let gradientColors: [Color] = [
    Color("Blue1"),
    Color("Green1"),
    Color("Blue1"),
    Color("Orange1"),
    Color("Green3")
]

//Haptic feedback variables
let impactSoft = UIImpactFeedbackGenerator(style: .soft)
let impactMedium = UIImpactFeedbackGenerator(style: .medium)
let impactHard = UIImpactFeedbackGenerator(style: .heavy)

let generator = UINotificationFeedbackGenerator()
