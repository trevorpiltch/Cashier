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
    @AppStorage("accountName") var accountName = "Trevor Piltch"
    
    @ObservedObject var itemModel: ExpenseModel
    @ObservedObject var tagModel: TagModel
    
    var body: some View {
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
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(itemModel: ExpenseModel(), tagModel: TagModel())
    }
}
