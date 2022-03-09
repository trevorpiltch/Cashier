//
//  CreatePasswordView.swift
//  Cashier (iOS)
//
//  Created by Trevor Piltch on 8/23/21.
//

import SwiftUI

struct CreatePasswordView: View {
    @AppStorage("Password") var password = ""
    @AppStorage("LockApp") var lockApp: Bool = false
    
    @State var password1 = ""
    @State var password2 = ""
    @State var samePassword = true
    @State var navigationTitle = "Add Password"
    
    @Binding var showAddPassword: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    if navigationTitle == "Add Password" {
                        Image(systemName: password1.count > 0 ? "circle.fill" : "circle")
                        Image(systemName: password1.count > 1 ? "circle.fill" : "circle")
                        Image(systemName: password1.count > 2 ? "circle.fill" : "circle")
                        Image(systemName: password1.count > 3 ? "circle.fill" : "circle")
                    }
                    else {
                        Image(systemName: password2.count > 0 ? "circle.fill" : "circle")
                        Image(systemName: password2.count > 1 ? "circle.fill" : "circle")
                        Image(systemName: password2.count > 2 ? "circle.fill" : "circle")
                        Image(systemName: password2.count > 3 ? "circle.fill" : "circle")
                    }
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
                
                HStack(spacing: (screen.width - 32) / 2) {
                    Button(action: {
                        addToPassword(number: "9")
                    }) {
                        Text("9")
                            .frame(width: 60, height: 60)
                            .background(Color("OffGray"))
                            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                    }
                    
                    Button(action: {
                        impactMedium.impactOccurred()
                        if navigationTitle == "Add Password" {
                            password1.removeLast()
                        }
                        else {
                            password2.removeLast()
                        }
                    }) {
                        Image(systemName: "delete.left.fill")
                            .frame(width: 60, height: 60)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                            .foregroundColor(.white)
                            .opacity(navigationTitle == "Add Password" ? password1.count == 0 ? 0.3 : 1 :  password2.count == 0 ? 0.3 : 1)
                    }
                    .disabled(navigationTitle == "Add Password" ? password1.count == 0 ? true : false :  password2.count == 0 ? true : false)
                
                }
                .padding(.bottom, screen.height / 11)
                .padding(.top)
                
                Text(samePassword ? "" : "The passwords don't match please try again.")
                    .multilineTextAlignment(.center)
                    .font(.body)
            }
            .font(.title2)
            .navigationBarTitle(Text("\(navigationTitle)"), displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                showAddPassword = false
                password1 = ""
                password2 = ""
                samePassword = true
                lockApp = false
            }) {
                Text("Cancel")
            }
            )
        }
    }
    
    func addToPassword(number: String) {
        impactMedium.impactOccurred()
        
        if password1.count < 4 && password2 == "" {
            password1.append(number)
            
            if password1.count == 4 {
                navigationTitle = "Re-enter Password"
            }
        }
        else if password2.count < 4{
            password2.append(number)
            
            if password2.count == 4 {
                samePassword = password1 == password2
                
                if samePassword {
                    password = password1
                    showAddPassword = false
                }
                else {
                    generator.notificationOccurred(.error)
                    password1 = ""
                    password2 = ""
                    navigationTitle = "Add Password"
                }
            }
        }
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePasswordView(showAddPassword: .constant(true))
    }
}
