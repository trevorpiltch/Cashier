//
//  HomeView.swift
//  Cashier
//
//  Created by Trevor Piltch on 12/20/20.
//

import SwiftUI
import SwiftUICharts

struct HomeView: View {
    //MARK: Variables
    //Passed through models
    @ObservedObject var expenseModel: ExpenseModel
    @ObservedObject var cardModel: CardModel
    @ObservedObject var tagModel: TagModel
    
    //Passed through variables
    @Binding var showCardDetail: Bool
    @Binding var index: Int
    var namespace: Namespace.ID
    
    //Variables to show sheets
    @State var showAddExpense = false
    @State var showPreferences = false
    
    //Other
    @State var showMoreRecents = false
    @State var selectedTime = "Month"
    @State var graphData: [(String, Double)] = []

    //MARK: Views
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                //Picker to select the timeframe for graph and totals
                Picker(selection: $selectedTime, label: Text("Time")) {
                    Text("Week").tag("Week")
                    Text("Month").tag("Month")
                    Text("Year").tag("Year")
                    Text("All").tag("All")
                }
                .onChange(of: selectedTime) { time in
                    //When the timeframe changes change it in the expenseModel and update the graph
                    expenseModel.time = selectedTime
                    expenseModel.sortData()
                    updateGraph()
                }
                .pickerStyle(SegmentedPickerStyle())
                
                //Shows the total expenses within the timeframe
                Text("$\(expenseModel.calculateTotal(), specifier: "%.2f")")
                    .font(.title)
                
                graph
                
                recents
                
                cards
                
                tags
            }
            .padding(.horizontal, 16)
        }
        .navigationBarItems(leading:
            //Button to show the preferences view sheet
            Button(action: {
                showPreferences = true
            }) {
                Image(systemName: "person.circle.fill")
            }
            .sheet(isPresented: $showPreferences) {
                SettingsView(itemModel: expenseModel, tagModel: tagModel)
            }, trailing:
            //Button to show the add expense sheet
            Button(action: {
                showAddExpense = true
            }) {
                Image(systemName: "plus")
            }
        )
        .onAppear {
            //When view appears update the graph and set the darkmode style to the darkmode styl
            updateGraph()
            chartStyle.darkModeStyle = darkChartStyle
        }
        .sheet(isPresented: $showAddExpense) {
            //Sheet to present the addExpense view
            AddExpenseView(itemModel: expenseModel, cardModel: cardModel, tagModel: tagModel)
        }
        .onReceive(expenseModel.objectWillChange) {
            //When something within the expensemodel changes update the graph
            updateGraph()
        }
    }
    
    //View with the graph of expense
    var graph: some View {
        VStack {
            HStack {
                Image(systemName: "chart.bar.xaxis")
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)
                    .padding(9)
                    .background(Color.purple)
                    .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                
                Text("Graph")
                
                Spacer()
            }
            .padding([.leading, .top])
            .font(.title)
            
            //Actual graph (from SwiftUICharts package
            BarChartView(data: ChartData(values: graphData), title: "", style: chartStyle, form: CGSize(width: screen.width - 44, height: screen.height / 4), dropShadow: false, cornerImage: Image(systemName: ""), valueSpecifier: "%.2f")
        }
        .frame(width: screen.width - 32, height: screen.height / 3)
        .background(Color("OffGray"))
        .cornerRadius(20)
    }
    
    //View that shows up to the 5 most recent expenses
    var recents: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "calendar")
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)
                    .padding(9)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                    .padding(.leading)
                
                Text("Recents")
                
                Spacer()
            }
            .font(.title)
            
            if expenseModel.data.count == 0 {
                //If there are no expenses
                Text("Add Something To Begin")
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
            }
            else if !showMoreRecents {
                //If the user hasn't tapped then only show the most recent expense
                NavigationLink(destination: ExpenseDetailView(expenseModel: expenseModel.getValue(obj: expenseModel.data[0]), masterExpenseModel: expenseModel, cardModel: cardModel, selectedObject: expenseModel.data[0])) {
                    //NavigationLink to the expenseDetailView
                    ExpenseRow(expenseModel: expenseModel.getValue(obj: expenseModel.data[0]))
                }
            }
            else {
                //If the user has tapped
                if (expenseModel.data.count < 5 && expenseModel.data.count > 0) {
                    //If the number of expenses is less than 5 and greater than 0 then just show all the expenses
                    ForEach(expenseModel.data.indices, id: \.self) { index in
                        NavigationLink(destination: ExpenseDetailView(expenseModel: expenseModel.getValue(obj: expenseModel.data[index]), masterExpenseModel: expenseModel, cardModel: cardModel, selectedObject: expenseModel.data[0])) {
                            //NavigationLink to the expenseDetailView
                            ExpenseRow(expenseModel: expenseModel.getValue(obj: expenseModel.data[index]))
                        }
                        
                        Divider()
                    }
                }
                else {
                    //If the number of expenses exceeds 5 then just show the first 5
                    ForEach(0..<5) { index in
                        NavigationLink(destination: ExpenseDetailView(expenseModel: expenseModel.getValue(obj: expenseModel.data[index]), masterExpenseModel: expenseModel, cardModel: cardModel, selectedObject: expenseModel.data[0])) {
                            //NavigationLink to the expenseDetailView
                            ExpenseRow(expenseModel: expenseModel.getValue(obj: expenseModel.data[index]))
                        }
                        
                        Divider()
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical)
        .frame(width: screen.width - 32, height: showMoreRecents ? expenseModel.data.count < 5 ? CGFloat(expenseModel.data.count * 100) : 450  : 150)
        .background(Color("OffGray"))
        .cornerRadius(20)
        .animation(.spring())
        .onTapGesture {
            if expenseModel.data.count > 1 {
                //When tapped and if there are expenses then toggle the show more recents
                showMoreRecents.toggle()
            }
        }
    }
    
    //View that shows all the users credit cards
    var cards: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "creditcard.fill")
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)
                    .padding(9)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                    .padding(.leading)
                
                
                Text("Cards")
                
                Spacer()
            }
            .font(.title)
            
            if cardModel.data.count == 0 {
                //If there are no cards to show
                Text("Add Something To Begin")
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
            }
            else {
                TabView {
                    ForEach(cardModel.data.indices, id: \.self) { i in
                        CardItem(card: cardModel.getValue(obj: cardModel.data[i]))
                            .matchedGeometryEffect(id: cardModel.getValue(obj: cardModel.data[i]).id, in: namespace, isSource: !showCardDetail)
                            .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0))
                            .scaleEffect(0.9)
                            .onTapGesture {
                                index = i
                                showCardDetail = true
                            }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            
            Spacer()
        }
        .padding(.vertical)
        .frame(width: screen.width - 32, height: cardModel.data.count == 0 ? 150 : 300)
        .background(Color("OffGray"))
        .cornerRadius(20)
    }
    
    var tags: some View {
        VStack {
            HStack {
                Image(systemName: "tag.fill")
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)
                    .padding(9)
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
                    .padding(.leading)
                
                Text("Tags")
                
                Spacer()
            }
            .font(.title)
            
            Spacer()
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 10) {
                    ForEach(tagModel.data, id: \.self) { data in
                        NavigationLink(destination: TagDetailView(expenseModel: expenseModel, cardModel: cardModel, tagModel: tagModel.getValue(obj: data))) {
                            TagItem(tagModel: tagModel.getValue(obj: data), isSelected: true, tags: .constant(nil))
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .frame(width: screen.width - 32, height: 150)
        .background(Color("OffGray"))
        .cornerRadius(20)
        .animation(.spring())
        .padding(.bottom)
    }
    
    // Update the graph based on the time sortby
    func updateGraph() {
        graphData.removeAll()
        dateFormatter.dateFormat = "MM/dd/yy"
        let filteredData = expenseModel.timeSortedData
        
        var amounts: [(String, Double)] = []
        
        for i in filteredData.indices {
            let currentDateFormatted = dateFormatter.string(from: expenseModel.getValue(obj: filteredData[i]).date)
            
            amounts.append((currentDateFormatted, (expenseModel.getValue(obj: filteredData[i]).amount)))
            
            var deletedAmount = 0

            for j in amounts.indices {
                if (amounts[j - deletedAmount].0 == amounts.last!.0 && (j - deletedAmount) != amounts.count - 1) {
                    amounts[amounts.count - 1].1 += amounts[j - deletedAmount].1
                    amounts.remove(at: j - deletedAmount)
                    deletedAmount += 1
                }
            }
        }
        graphData = amounts
    }
}

struct DashboardView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        HomeView(expenseModel: ExpenseModel(), cardModel: CardModel(company: "Norway", number: "0000-0000", gradient: 0, name: "", id: UUID()), tagModel: TagModel(), showCardDetail: .constant(false), index: .constant(0), namespace: namespace)
    }
}

// For the bar graph
let chartStyle = ChartStyle(backgroundColor: Color("OffGray"), accentColor: Color.accentColor, gradientColor: GradientColor(start: Color.accentColor, end: Color.accentColor), textColor: Color("Text"), legendTextColor: Color("Text"), dropShadowColor: Color("Background"))

let darkChartStyle = ChartStyle(backgroundColor: Color("OffGray"), accentColor: Color.accentColor, gradientColor: GradientColor(start: Color.accentColor, end: Color.accentColor), textColor: Color("Text"), legendTextColor: Color.black, dropShadowColor: Color("Background"))

