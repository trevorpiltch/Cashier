//
//  SettingsView.swift
//  Cashier
//
//  Created by Trevor Piltch on 12/20/20.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("LockApp") var lockApp: Bool = false
    @AppStorage("UseFaceID") var useFaceID = false
    @AppStorage("accountName") var accountName = "Trevor Piltch"
    
    @ObservedObject var itemModel: ExpenseModel
    @ObservedObject var tagModel: TagModel
    
    @State var showAddPassword = false
    
    var body: some View {
        ZStack {
            if !showAddPassword {
                settings
            }
            else {
                CreatePasswordView(showAddPassword: $showAddPassword)
            }
        }
    }
    
    var settings: some View {
        NavigationView {
            List {
                Section(header: Text("General")) {
                    HStack {
                        RoundedRectImageItem(imageName: "person.circle.fill", color: .blue, size: 36)
                        
                        VStack(alignment: .leading) {
                            Text(accountName)
                                .font(.title2)
                                .bold()
                            
                            Text("Total Spending: $\(itemModel.calculateTotal(), specifier: "%.2f")")
                        }
                    }
                    
                    HStack {
                        RoundedRectImageItem(imageName: "lock.circle.fill", color: .red, size: 36)
                        
                        Text("Lock App")
                        
                        Spacer()
                        
                        Toggle(isOn: $lockApp) {
                            EmptyView()
                        }
                    }
                    .onChange(of: self.lockApp) { value in
                        if lockApp {
                            showAddPassword = true
                        }
                    }
                    
                    if lockApp {
                        HStack {
                            RoundedRectImageItem(imageName: "face.smiling.fill", color: .green, size: 36)
                            
                            Text("Use Biometrics")
                            
                            Spacer()
                            
                            Toggle(isOn: $useFaceID) {
                                EmptyView()
                            }
                        }
                    }
                    
                    HStack {
                        RoundedRectImageItem(imageName: "tag.circle.fill", color: .orange, size: 36)
                        
                        NavigationLink(destination: ManageTagsView(tagModel: tagModel)) {
                            Text("Manage Tags")
                        }
                    }
                    
                    
                    
                    HStack {
                        RoundedRectImageItem(imageName: "rectangle.on.rectangle.circle.fill", color: .yellow, size: 36)
                        
                        NavigationLink(destination: AppIconView()) {
                            Text("App Icon")
                        }
                    }
                }
                
                Section(header: Text("Advanced")) {
                    HStack {
                        RoundedRectImageItem(imageName: "hammer.circle.fill", color: .accentColor, size: 36)
                        
                        Text("Version")
                        
                        Spacer()
                        
                        Text("2.0")
                    }
                    
                    HStack {
                        RoundedRectImageItem(imageName: "figure.wave.circle.fill", color: .purple, size: 36)
                        
                        Text("About")
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
            })
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Preferences")
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(itemModel: ExpenseModel(), tagModel: TagModel())
    }
}
