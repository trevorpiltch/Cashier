//
//  HomeView.swift
//  Cashier
//
//  Created by Trevor Piltch on 12/20/20.
//

import SwiftUI
import SwiftUICharts

struct HomeView: View {
    @ObservedObject var itemModel: ExpenseModel
    @ObservedObject var cardModel: CardModel
    
    let dateFormatter = DateFormatter()
    
    @State var showAddExpense = false
    @State var showAddIncome = false
    @State var showSettings = false
    @State var showMoreRecents = false
    
    @State var selectedTime = "Month"
    @State var selectedType = "Expense"
    @State var graphData: [(String, Double)] = []
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Picker(selection: $selectedTime, label: Text("Time")) {
                        Text("Week").tag("Week")
                        Text("Month").tag("Month")
                        Text("Year").tag("Year")
                        Text("All").tag("All")
                    }
                    .onChange(of: selectedTime) { time in
                        itemModel.time = selectedTime
                        itemModel.sortData()
                        updateGraph()
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Text("$\(itemModel.calculateTotal(), specifier: "%.2f")")
                        .font(.title)
                    
                    graph
                        .frame(width: screen.width - 32, height: screen.height / 3)
                        .background(Color("OffGray"))
                        .cornerRadius(20)

                   recents
                    
                    cards
                    .padding(.vertical)
                    .frame(width: screen.width - 32, height: cardModel.data.count == 0 ? 150 : 300)
                    .background(Color("OffGray"))
                    .cornerRadius(20)
                    .animation(.spring())
                }
                .padding(.horizontal, 16)
            }
            
            .navigationTitle("Home")
            .navigationBarItems(leading:
                                    Button(action: {
                                        showSettings = true
                                    }) {
                                        Image(systemName: "person.circle.fill")
                                    }
                .sheet(isPresented: $showSettings) {
                    SettingsView(itemModel: itemModel)
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
                AddExpenseView(itemModel: itemModel, cardModel: cardModel)
            }
            .onReceive(itemModel.objectWillChange) {
                updateGraph()
            }
        }
    }
    
    var graph: some View {
        VStack {
            HStack {
                Image(systemName: "chart.bar.xaxis")
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)
                    .padding(9)
                    .background(Color.orange)
                    .clipShape(Circle())
                
                Text("Graph")
                
                Spacer()
            }
            .padding([.leading, .top])
            .font(.title)
            
            BarChartView(data: ChartData(values: graphData), title: "", style: chartStyle, form: CGSize(width: screen.width - 44, height: screen.height / 4), dropShadow: false, cornerImage: Image(systemName: ""), valueSpecifier: "%.2f")
        }
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
                    .clipShape(Circle())
                    .padding(.leading)
                
                Text("Recents")
                
                Spacer()
                
                NavigationLink(destination: AllExpensesView()) {
                    Text("See All")
                        .font(.body)
                }
                .padding(.horizontal)
            }
            .font(.title)
            
            if itemModel.data.count == 0 {
                Text("Add Something To Begin")
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
            }
            else if !showMoreRecents {
                ItemRow(itemModel: itemModel, index: 0)
            }
            else {
                if (itemModel.data.count < 5 && itemModel.data.count > 0) {
                    ForEach(itemModel.data.indices, id: \.self) { i in
                        ItemRow(itemModel: itemModel, index: i)
                    }
                }
                else {
                    ForEach(0..<5) { i in
                        ItemRow(itemModel: itemModel, index: i)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical)
        .frame(width: screen.width - 32, height: showMoreRecents ? 500 : 150)
        .background(Color("OffGray"))
        .cornerRadius(20)
        .animation(.spring())
        .onTapGesture {
            showMoreRecents.toggle()
        }
    }
    
    var cards: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "creditcard")
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)
                    .padding(9)
                    .background(Color.blue)
                    .clipShape(Circle())
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
    }
    
    // Update the graph based on the time sortby
    func updateGraph() {
        graphData.removeAll()
        dateFormatter.dateFormat = "MM/dd/yy"
        let filteredData = itemModel.timeSortedData.filter {
            itemModel.getValue(obj: $0).type == selectedType
        }
        var amounts: [(String, Double)] = []
        
        for i in filteredData.indices {
            let currentDateFormatted = dateFormatter.string(from: itemModel.getValue(obj: filteredData[i]).date)
            
            amounts.append((currentDateFormatted, (itemModel.getValue(obj: filteredData[i]).amount)))
            
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
    }}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(itemModel: ExpenseModel(), cardModel: CardModel(company: "Norway", number: "0000-0000", gradient: 0, name: "", id: UUID()))
    }
}

// For the bar graph
let chartStyle = ChartStyle(backgroundColor: Color("OffGray"), accentColor: Color.accentColor, gradientColor: GradientColor(start: Color.accentColor, end: Color.accentColor), textColor: Color("Text"), legendTextColor: Color("Text"), dropShadowColor: Color("Background"))

let darkChartStyle = ChartStyle(backgroundColor: Color("OffGray"), accentColor: Color.accentColor, gradientColor: GradientColor(start: Color.accentColor, end: Color.accentColor), textColor: Color("Text"), legendTextColor: Color.black, dropShadowColor: Color("Background"))

