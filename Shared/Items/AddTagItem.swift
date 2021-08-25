//
//  AddTagItem.swift
//  Cashier (iOS)
//
//  Created by Trevor Piltch on 8/14/21.
//

import SwiftUI

struct AddTagItem: View {
    @ObservedObject var tagModel: TagModel
    @State var name = ""
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 103, height: 47)
                .background(Color.accentColor)
                .foregroundColor(.accentColor)
                .cornerRadius(11)
            
            HStack {
                Image(systemName: "plus")
                
                TextField("Add Tag", text: $name, onCommit: {
                    tagModel.name = name
                    tagModel.id = UUID()
                    tagModel.writeData()
                    name = ""
                })
            }
            .padding(5)
            .foregroundColor(Color("Text").opacity(0.8))
            .frame(width: 100, height: 44)
            .background(Color("OffGray"))
            .cornerRadius(9)
        }

    }
}

struct AddTagItem_Previews: PreviewProvider {
    static var previews: some View {
        AddTagItem(tagModel: TagModel(name: "Add Tag", id: UUID()))
    }
}
