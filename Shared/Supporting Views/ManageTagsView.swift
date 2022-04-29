//
//  ManageTagsView.swift
//  Cashier (iOS)
//
//  Created by Trevor Piltch on 8/22/21.
//

import SwiftUI
import CoreData

struct ManageTagsView: View {
    @ObservedObject var tagModel: TagModel
    
    @State var showDeleteConfirm = false
    @State var selectedObject: [NSManagedObject] = []
    
    var body: some View {
        List {
            ForEach(tagModel.data, id: \.self) { data in
                HStack {
                    Text(tagModel.getValue(obj: data).name)
                    
                    Spacer()
                    
                    Button(action: {
                        selectedObject = [data]
                        showDeleteConfirm = true
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color.red)
                            .frame(width: 44, height: 44)
                    }
                }
            }
            
            TextField("Add Tag", text: $tagModel.name, onCommit: {
                tagModel.id = UUID()
                tagModel.writeData()
            })
        }
        .listStyle(InsetGroupedListStyle())
        .actionSheet(isPresented: $showDeleteConfirm) {
            ActionSheet(title: Text("Perform Delete?"), message: Text("Are you sure you want to delete this tag? This action cannot be undone."), buttons: [
                .destructive(Text("Delete"), action: {
                    tagModel.deleteData(id: tagModel.getValue(obj: selectedObject[0]).id)
                }),
                .cancel()
            ]
            )
        }
        .navigationTitle("Manage Tags")
        
    }
}

struct ManageTagsView_Previews: PreviewProvider {
    static var previews: some View {
        ManageTagsView(tagModel: TagModel())
    }
}
