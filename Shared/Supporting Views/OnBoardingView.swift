//
//  OnBoardingView.swift
//  Cashier
//
//  Created by Trevor Piltch on 8/13/21.
//

import SwiftUI

struct OnBoardingView: View {
    @AppStorage("accountName") var accountName = ""
    @AppStorage("hasOpened") var hasOpened = false
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Welcome to Cashier")
                .font(.largeTitle)
                .padding()
            
            Image("Icon")
                .resizable()
                .frame(width: 132, height: 132)
            
            VStack {
                HStack {
                    RoundedRectImageItem(imageName: "figure.walk.circle.fill", color: .orange, size: 36)
                    
                    Text("Cashier is your personal financial assistant. Keep track of expenses and see your weekly, monthly, and yearly totals.")
                        
                }
                .padding()
                
                Divider()
                
                HStack {
                    RoundedRectImageItem(imageName: "lock.circle.fill", color: .red, size: 36)
                    
                    Text("Cashier keeps everything on device and safe. You can even protect the app with a passcode or bioauthentication.")
                }
                .padding()
                
                Spacer()
            }
            .multilineTextAlignment(.leading)
            .frame(width: screen.width - 32, height: 250)
            .background(Color("OffGray"))
            .cornerRadius(22)
            
            VStack {
                HStack {
                    RoundedRectImageItem(imageName: "person.circle.fill", color: .accentColor, size: 36)
                    
                    TextField("Account Name", text: $accountName)
                }
                .padding()
            }
            .multilineTextAlignment(.leading)
            .frame(width: screen.width - 32, height: 80)
            .background(Color("OffGray"))
            .cornerRadius(22)
            .padding(.top)
            
            Spacer()
            
            Button(action: {
                hasOpened = true
            }) {
                Text("Begin")
                    .frame(width: screen.width - 22, height: 44)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(11)
            }
            .disabled(accountName == "")
        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
