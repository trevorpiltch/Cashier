//
//  AboutPage.swift
//  Cashier (iOS)
//
//  Created by Trevor Piltch on 8/25/21.
//

import SwiftUI

struct AboutPage: View {
    var body: some View {
        List {
            Section(header: Text("Description")) {
                Text("Cashier was created and is maintained by one developer. (Hi that's me!) All your data stays on your phone and none of it is sent to the cloud or to third parties. Have questions? Email me at trevor@piltch.com")
                    .multilineTextAlignment(.leading)
            }
            
            Section(header: Text("2021 Dedication")) {
                Text("Cashier is dedicated to everyone around the world working to save democracy.")
                    .multilineTextAlignment(.leading)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("About")
    }
}

struct AboutPage_Previews: PreviewProvider {
    static var previews: some View {
        AboutPage()
    }
}
