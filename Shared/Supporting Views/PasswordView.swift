//
//  PasswordView.swift
//  Cashier (iOS)
//
//  Created by Trevor Piltch on 8/24/21.
//

import SwiftUI

struct PasswordView: View {
    @AppStorage("Password") var appPassword = ""
    @AppStorage("LockApp") var lockApp: Bool = false
    
    @State var password = ""
    @State var samePassword = true
    
    @Binding var isUnlocked: Bool
    @Binding var authenticate: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: password.count > 0 ? "circle.fill" : "circle")
                    Image(systemName: password.count > 1 ? "circle.fill" : "circle")
                    Image(systemName: password.count > 2 ? "circle.fill" : "circle")
                    Image(systemName: password.count > 3 ? "circle.fill" : "circle")
                }
                .foregroundColor(.accentColor)
                .font(.largeTitle)
                .padding(.vertical, 50)
                
                Spacer()
                
                HStack(spacing: (screen.width - 32) / 6) {
                    Button(action: {
                        addToPassword(number: "0")
                    }) {
                        Text("0")
                            .frame(width: 60, height: 60)
                            .background(Color("OffGray"))
                            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                    }
                    
                    Button(action: {
                        addToPassword(number: "1")
                    }) {
                        Text("1")
                            .frame(width: 60, height: 60)
                            .background(Color("OffGray"))
                            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                    }
                    
                    Button(action: {
                        addToPassword(number: "2")
                    }) {
                        Text("2")
                            .frame(width: 60, height: 60)
                            .background(Color("OffGray"))
                            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                    }
                }
                .padding()
                
                HStack(spacing: (screen.width - 32) / 6) {
                    Button(action: {
                        addToPassword(number: "3")
                    }) {
                        Text("3")
                            .frame(width: 60, height: 60)
                            .background(Color("OffGray"))
                            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                    }
                    
                    Button(action: {
                        addToPassword(number: "4")
                    }) {
                        Text("4")
                            .frame(width: 60, height: 60)
                            .background(Color("OffGray"))
                            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                    }

                    Button(action: {
                        addToPassword(number: "5")
                    }) {
                        Text("5")
                            .frame(width: 60, height: 60)
                            .background(Color("OffGray"))
                            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                    }
                }
                .padding()
                
                HStack(spacing: (screen.width - 32) / 6) {
                    Button(action: {
                        addToPassword(number: "6")
                    }) {
                        Text("6")
                            .frame(width: 60, height: 60)
                            .background(Color("OffGray"))
                            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                    }
                    
                    Button(action: {
                        addToPassword(number: "7")
                    }) {
                        Text("7")
                            .frame(width: 60, height: 60)
                            .background(Color("OffGray"))
                            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                    }
                    
                    Button(action: {
                        addToPassword(number: "8")
                    }) {
                        Text("8")
                            .frame(width: 60, height: 60)
                            .background(Color("OffGray"))
                            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                    }
                }
                .padding()
                
                HStack(spacing: (screen.width - 32) / 6) {
                    Button(action: {
                        authenticate = true
                    }) {
                        Image(systemName: "faceid")
                            .frame(width: 60, height: 60)
                            .background(Color.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        addToPassword(number: "9")
                    }) {
                        Text("9")
                            .frame(width: 60, height: 60)
                            .background(Color("OffGray"))
                            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                    }
                
                    
                    Button(action: {
                        password.removeLast()
                    }) {
                        Image(systemName: "delete.left.fill")
                            .frame(width: 60, height: 60)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                            .foregroundColor(.white)
                            .opacity(password.count == 0 ? 0.3 : 1)
                    }
                    .disabled(password.count == 0 ? true : false)
                }
                .padding(.top)
                .padding(.bottom, screen.height / 11)
                
                Text(samePassword ? "" : "The passwords don't match please try again.")
                    .multilineTextAlignment(.center)
                    .font(.body)
            }
            .navigationBarTitle(Text("Password"), displayMode: .inline)
        }
    }
    
    func addToPassword(number: String) {
        if password.count < 4 {
            password.append(number)
        }
        
        if password.count == 4 {
            samePassword = password == appPassword
            
            if samePassword {
                if lockApp {
                    isUnlocked = true
                    samePassword = true
                    password = ""
                }
                else {
                    lockApp = false
                    password = ""
                    appPassword = ""
                    samePassword = true
                }
            }
            else {
                password = ""
            }
        }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView(isUnlocked: .constant(false), authenticate: .constant(false))
    }
}
