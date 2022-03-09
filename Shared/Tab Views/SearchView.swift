//
//  SearchView.swift
//  Cashier
//
//  Created by Trevor Piltch on 2/8/21.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var expenseModel: ExpenseModel
    @ObservedObject var cardModel: CardModel
    @ObservedObject var tagModel: TagModel
    
    // Search string to use in the search bar
    @State var searchString = ""
    @State var tags: [String]? = nil
    @State var sortby = "Date"
    
    // Search action. Called when search key pressed on keyboard
    func search() {
    }
    
    // Cancel action. Called when cancel button of search bar pressed
    func cancel() {
        searchString = ""
    }
    
    // View body
    var body: some View {
        // Search Navigation. Can be used like a normal SwiftUI NavigationView.
        SearchNavigation(text: $searchString, search: search, cancel: cancel) {
            // Example SwiftUI View
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(expenseModel.data.filter {
                        if searchString != "" {
                            return expenseModel.getValue(obj: $0).item.lowercased().contains(searchString.lowercased()) || "\(expenseModel.getValue(obj: $0).amount)".contains(searchString)
                        }
                        else {
                            return true
                        }
                    }.sorted {
                        if sortby == "date descending" {
                            return expenseModel.getValue(obj: $0).date > expenseModel.getValue(obj: $1).date
                        }
                        else if sortby == "date ascending" {
                            return expenseModel.getValue(obj: $0).date < expenseModel.getValue(obj: $1).date
                        }
                        else if sortby == "amount high to low" {
                            return expenseModel.getValue(obj: $0).amount > expenseModel.getValue(obj: $1).amount
                        }
                        else if sortby == "amount low to high" {
                            return expenseModel.getValue(obj: $0).amount < expenseModel.getValue(obj: $1).amount
                        }
                        else {
                            return true
                        }
                    }, id: \.self) { data in
                        NavigationLink(destination: ExpenseDetailView(expenseModel: expenseModel.getValue(obj: data), masterExpenseModel: expenseModel, cardModel: cardModel, selectedObject: data)) {
                            ExpenseRow(expenseModel: expenseModel.getValue(obj: data))
                        }
                    }
                    
                    
                    Spacer()
                }
                .navigationTitle("Search")
                .navigationBarItems(trailing:
                    Menu("\(Image(systemName: "arrow.up.arrow.down"))") {
                        Button(action: {
                            sortby = "date descending"
                        }) {
                            Label("Newest to oldest", systemImage: "calendar.day.timeline.left")
                        }
                        Button(action: {
                            sortby = "date ascending"
                        }) {
                            Label("Oldest to newest", systemImage: "calendar.day.timeline.right")
                        }
                        Button(action: {
                            sortby = "amount high to low"
                        }) {
                            Label("Amount high to low", systemImage: "creditcard")
                        }
                        Button(action: {
                            sortby = "amount low to high"
                        }) {
                            Label("Amount low to high", systemImage: "banknote")
                        }
                        
                    }
                )
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(expenseModel: ExpenseModel(), cardModel: CardModel(), tagModel: TagModel())
    }
}


struct SearchNavigation<Content: View>: UIViewControllerRepresentable {
    @Binding var text: String
    var search: () -> Void
    var cancel: () -> Void
    var content: () -> Content
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: context.coordinator.rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        context.coordinator.searchController.searchBar.delegate = context.coordinator
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        context.coordinator.update(content: content())
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(content: content(), searchText: $text, searchAction: search, cancelAction: cancel)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        let rootViewController: UIHostingController<Content>
        let searchController = UISearchController(searchResultsController: nil)
        var search: () -> Void
        var cancel: () -> Void
        
        init(content: Content, searchText: Binding<String>, searchAction: @escaping () -> Void, cancelAction: @escaping () -> Void) {
            rootViewController = UIHostingController(rootView: content)
            searchController.searchBar.autocapitalizationType = .none
            searchController.obscuresBackgroundDuringPresentation = false
            rootViewController.navigationItem.searchController = searchController
            
            _text = searchText
            search = searchAction
            cancel = cancelAction
        }
        
        func update(content: Content) {
            rootViewController.rootView = content
            rootViewController.view.setNeedsDisplay()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            search()
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            cancel()
        }
    }
    
}
