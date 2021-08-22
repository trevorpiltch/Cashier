//
//  HomeView.swift
//  Cashier
//
//  Created by Trevor Piltch on 12/20/20.
//

import SwiftUI
import SwiftUICharts

struct HomeView: View {
    @ObservedObject var expenseModel: ExpenseModel
    @ObservedObject var cardModel: CardModel
    @ObservedObject var tagModel: TagModel
    
    let dateFormatter = DateFormatter()
    
    @State var showAddExpense = false
    @State var showAddIncome = false
    @State var showSettings = false
    @State var showMoreRecents = false
    
    @State var selectedTime = "Month"
    @State var selectedType = "Expense"
    @State var graphData: [(String, Double)] = []
    
    var body: some View {
//        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Picker(selection: $selectedTime, label: Text("Time")) {
                        Text("Week").tag("Week")
                        Text("Month").tag("Month")
                        Text("Year").tag("Year")
                        Text("All").tag("All")
                    }
                    .onChange(of: selectedTime) { time in
                        expenseModel.time = selectedTime
                        expenseModel.sortData()
                        updateGraph()
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
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
                                    Button(action: {
                                        showSettings = true
                                    }) {
                                        Image(systemName: "person.circle.fill")
                                    }
                .sheet(isPresented: $showSettings) {
                SettingsView(itemModel: expenseModel, tagModel: tagModel)
                }
                                ,
                                trailing:
                                    
                                    Button(action: {
                showAddExpense = true
            }) {
                Image(systemName: "plus")
                
            }
            )
            .onAppear {
                dateFormatter.dateStyle = .short
                updateGraph()
                chartStyle.darkModeStyle = darkChartStyle
            }
            .sheet(isPresented: $showAddExpense) {
                AddExpenseView(itemModel: expenseModel, cardModel: cardModel, tagModel: tagModel)
            }
            .onReceive(expenseModel.objectWillChange) {
                updateGraph()
            }
    }
    
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
            
            BarChartView(data: ChartData(values: graphData), title: "", style: chartStyle, form: CGSize(width: screen.width - 44, height: screen.height / 4), dropShadow: false, cornerImage: Image(systemName: ""), valueSpecifier: "%.2f")
        }
        .frame(width: screen.width - 32, height: screen.height / 3)
        .background(Color("OffGray"))
        .cornerRadius(20)
    }
    
    var recents: some View {
        //Recents stuff
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
                Text("Add Something To Begin")
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
            }
            else if !showMoreRecents {
                NavigationLink(destination: ExpenseDetailView(expenseModel: expenseModel.getValue(obj: expenseModel.data[0]), masterExpenseModel: expenseModel, cardModel: cardModel, selectedObject: expenseModel.data[0])) {
                    ExpenseRow(expenseModel: expenseModel.getValue(obj: expenseModel.data[0]))
                }
            }
            else {
                if (expenseModel.data.count < 5 && expenseModel.data.count > 0) {
                    ForEach(expenseModel.data.indices, id: \.self) { index in
                        NavigationLink(destination: ExpenseDetailView(expenseModel: expenseModel.getValue(obj: expenseModel.data[index]), masterExpenseModel: expenseModel, cardModel: cardModel, selectedObject: expenseModel.data[0])) {
                            ExpenseRow(expenseModel: expenseModel.getValue(obj: expenseModel.data[index]))
                        }
                        
                        Divider()
                    }
                }
                else {
                    ForEach(0..<5) { index in
                        NavigationLink(destination: ExpenseDetailView(expenseModel: expenseModel.getValue(obj: expenseModel.data[index]), masterExpenseModel: expenseModel, cardModel: cardModel, selectedObject: expenseModel.data[0])) {
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
                showMoreRecents.toggle()
            }
        }
    }
    
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
                Text("Add Something To Begin")
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
            }
            else {
                TabView {
                    ForEach(cardModel.data.indices, id: \.self) { i in
                        CardItem(card: cardModel.getValue(obj: cardModel.data[i]))
                            .scaleEffect(0.9)
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
        .animation(.spring())
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
                        NavigationLink(destination: TagDetailView(expenseModel: expenseModel, cardModel: cardModel, tagModel: tagModel)) {
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
        let filteredData = expenseModel.timeSortedData.filter {
            expenseModel.getValue(obj: $0).type == selectedType
        }
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
    static var previews: some View {
        HomeView(expenseModel: ExpenseModel(), cardModel: CardModel(company: "Norway", number: "0000-0000", gradient: 0, name: "", id: UUID()), tagModel: TagModel())
    }
}

// For the bar graph
let chartStyle = ChartStyle(backgroundColor: Color("OffGray"), accentColor: Color.accentColor, gradientColor: GradientColor(start: Color.accentColor, end: Color.accentColor), textColor: Color("Text"), legendTextColor: Color("Text"), dropShadowColor: Color("Background"))

let darkChartStyle = ChartStyle(backgroundColor: Color("OffGray"), accentColor: Color.accentColor, gradientColor: GradientColor(start: Color.accentColor, end: Color.accentColor), textColor: Color("Text"), legendTextColor: Color.black, dropShadowColor: Color("Background"))

