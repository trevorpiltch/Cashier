//
//  SettingsView.swift
//  Cashier
//
//  Created by Trevor Piltch on 12/20/20.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("LockApp") var lockApp: Bool = false
    
    @State var showAppearance = false
    
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Lock App")
                    
                    Spacer()
                    
                    Toggle(isOn: $lockApp) {
                        EmptyView()
                    }
                }
                
                HStack {
                    Text("Version")
                    
                    Spacer()
                    
                    Text("2.0")
                }
            }
            .navigationTitle("Settings")        
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
