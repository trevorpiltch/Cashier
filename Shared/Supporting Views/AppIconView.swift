//
//  AppIconView.swift
//  Cashier (iOS)
//
//  Created by Trevor Piltch on 8/21/21.
//

import SwiftUI

struct AppIconView: View {
    @AppStorage("AppIcon") var appIcon = "Default"
    
    var body: some View {
        List {
            HStack {
                Image("green")
                    .cornerRadius(11)
                    .scaleEffect(0.8)
                    .frame(width: 52, height: 52)
                    
                Text("Default")
                
                Spacer()
                
                Button(action: {
                    UIApplication.shared.setAlternateIconName("Green") { (error) in
                        if let error = error {
                            print("err: \(error)")
                        }
                    }
                    appIcon = "Default"
                }) {
                    Image(systemName: appIcon == "Default" ? "checkmark.circle.fill" : "circle")
                }
            }
            
            HStack {
                Image("blue")
                    .cornerRadius(11)
                    .scaleEffect(0.8)
                    .frame(width: 52, height: 52)
                    
                Text("Blue")
                
                Spacer()
                
                Button(action: {
                    UIApplication.shared.setAlternateIconName("Blue") { (error) in
                        if let error = error {
                            print("err: \(error.localizedDescription)")
                        }
                    }
                    appIcon = "Blue"
                }) {
                    Image(systemName: appIcon == "Blue" ? "checkmark.circle.fill" : "circle")
                }
            }
            
            HStack {
                Image("white")
                    .cornerRadius(11)
                    .scaleEffect(0.8)
                    .frame(width: 52, height: 52)
                    
                Text("White")
                
                Spacer()
                
                Button(action: {
                    UIApplication.shared.setAlternateIconName("White") { (error) in
                        if let error = error {
                            print("err: \(error)")
                        }
                    }
                    appIcon = "White"
                }) {
                    Image(systemName: appIcon == "White" ? "checkmark.circle.fill" : "circle")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("App Icon")
    }
}

struct AppIconView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconView()
    }
}
