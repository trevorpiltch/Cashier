//
//  TagItem.swift
//  Cashier (iOS)
//
//  Created by Trevor Piltch on 8/14/21.
//

import SwiftUI

struct TagItem: View {
    @ObservedObject var tagModel: TagModel
    
    @State var isSelected: Bool = false
    @Binding var tags: [String]?
    
    var body: some View {
        VStack {
            Text(tagModel.name)
        }
        .foregroundColor(isSelected ? Color.white : Color("Text").opacity(0.6))
        .frame(width: CGFloat(tagModel.name.count * 10 + 10), height: 44)
        .background(isSelected ? Color.accentColor : Color.black.opacity(0.2))
        .cornerRadius(11)
        .onTapGesture {
            if tags != nil {
                if isSelected && !tags!.isEmpty {
                    let index = tags!.firstIndex(of: tagModel.name)!
                    tags!.remove(at: index)
                }
                else {
                    tags!.append(tagModel.name)
                }
                isSelected.toggle()
            }
        }
    }
}

struct TagItem_Previews: PreviewProvider {
    static var previews: some View {
        TagItem(tagModel: TagModel(name: "Test Tag", id: UUID()), isSelected: false, tags: .constant(["name"]))
    }
}
