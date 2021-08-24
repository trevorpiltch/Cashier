//
//  CreatePasswordView.swift
//  Cashier (iOS)
//
//  Created by Trevor Piltch on 8/23/21.
//

import SwiftUI

struct CreatePasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("Password") var password = ""
    
    @State var password1 = ""
    @State var password2 = ""
    @State var samePassword = true
    @State var navigationTitle = "Add Password"
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    HStack {
                        Image(systemName: password1.count > 0 ? "circle.fill" : "circle")
                        Image(systemName: password1.count > 1 ? "circle.fill" : "circle")
                        Image(systemName: password1.count > 2 ? "circle.fill" : "circle")
                        Image(systemName: password1.count > 3 ? "circle.fill" : "circle")
                    }
                    .foregroundColor(.accentColor)
                    .font(.largeTitle)
                    .padding(.vertical, 50)
                }
                
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
                
                Button(action: {
                    addToPassword(number: "9")
                }) {
                    Text("9")
                        .frame(width: 60, height: 60)
                        .background(Color("OffGray"))
                        .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                }
                .padding(.bottom, screen.height / 11)
            
//                Spacer()
                
                Text(samePassword ? "" : "The passwords don't match please try again.")
                    .multilineTextAlignment(.center)
                    .font(.body)
            }
            .font(.title2)
            .navigationBarTitle(Text("\(navigationTitle)"), displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: {
                password1 = ""
                password2 = ""
                samePassword = true
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
            }
            )
        }
    }
    
    func addToPassword(number: String) {
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
                    presentationMode.wrappedValue.dismiss()
                }
                else {
                    password1 = ""
                    password2 = ""
                }
            }
        }
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePasswordView()
    }
}
