//
//  InsightsView.swift
//  Pomdera Watch App
//
//  Created by Luiz Felipe on 25/11/24.
//

import SwiftUI
import Charts


struct InsightsView: View {
    @StateObject private var viewModel = InsightsViewModel()
    var body: some View {
        TabView {
//            FocusInsightsView(viewModel: self.viewModel)
//            BreakInsightsView(viewModel: self.viewModel)
            TagsInsightsView(viewModel: self.viewModel)
        }.tabViewStyle(.verticalPage)
            
    }
    
    
}

struct FocusInsightsView: View {
    @State var viewModel : InsightsViewModel
    @State private var insightsData: InsightsDataModel?
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("Foco")
                    .bold()
                    .padding(.horizontal, 10)
                    
            }
            if let insights = insightsData {
                Chart(insights.timeFocusPerHour, id: \.self) {
                    BarMark(
                        x: .value("Date", $0.hour),
                        y: .value("Sales", $0.value),
                        width: insights.timeFocusPerHour.count < 5 ? .fixed(10) : .automatic
                        
                    )
                    .foregroundStyle(Color("ChartsBarFocus"))
                }
                .chartXAxis(.automatic)
                .chartYAxis(.hidden)
                .frame(minHeight: 90)
                .padding(.horizontal, 10)
                
                HStack{
                    Text("\(self.viewModel.dateFormatter())")
                        .font(.system(size: 12))
                        .bold()
                        .foregroundStyle(Color("TextFocus"))
                    
                    Spacer()
                }.padding(1)
                HStack{
                    Text("\(viewModel.formatMinutesToHours(minutes: insights.timeFocusedTotal))")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundStyle(.white)
                    
                    Spacer()
                }.padding(1)
            } else {
                ProgressView("Carregando...")
            }
        }
        .onAppear {
            self.insightsData = InsightsDataModel(timeFocusedInMinutes: [], timeFocusedTotal: 20,timeFocusPerHour: [ChartData(hour: 5, value: 10),ChartData(hour: 6, value: 110), ChartData(hour: 08, value: 20)], timeBreakPerHour: [ChartData(hour: 5, value: 10),ChartData(hour: 6, value: 110), ChartData(hour: 08, value: 20)], timeTotalInMinutes: 02, timeBreakInMinutes: 10)
            //            viewModel.getInsights { data in
            //                self.insightsData = data
            //            }
        }
        .background(Gradient(colors: [ Color("GradienteFocus"), .black]), ignoresSafeAreaEdges: .all)
        
        
        
    }
}
struct BreakInsightsView: View {
    @State var viewModel : InsightsViewModel
    @State private var insightsData: InsightsDataModel?
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Text("Intervalo")
                    .bold()
                    .padding(.horizontal, 10)
                    
            }
            if let insights = insightsData {
                
                Chart(insights.timeBreakPerHour, id: \.self) {
                    BarMark(
                        x: .value("Date", $0.hour),
                        y: .value("Sales", $0.value),
                        width: insights.timeBreakPerHour.count < 5 ? .fixed(10) : .automatic
                        
                    )
                    .foregroundStyle(Color("ChartsBarBreak"))
                }
                .chartXAxis(.automatic)
                .chartYAxis(.hidden)
                .frame(minHeight: 90)
                .padding(.horizontal, 10)
                
                HStack{
                    Text("\(self.viewModel.dateFormatter())")
                        .foregroundStyle(Color("TextBreak"))
                        .font(.system(size: 12))
                        .bold()
                    Spacer()
                }.padding(1)
                HStack{
                    Text("\(viewModel.formatMinutesToHours(minutes: insights.timeBreakInMinutes))")
                        .font(.system(size: 20))
                        .bold()
                    Spacer()
                }.padding(1)
            } else {
                ProgressView("Carregando...")
            }
        }
        .onAppear {
            self.insightsData = InsightsDataModel(timeFocusedInMinutes: [], timeFocusedTotal: 20,timeFocusPerHour: [ChartData(hour: 5, value: 10),ChartData(hour: 6, value: 110), ChartData(hour: 08, value: 20)], timeBreakPerHour: [ChartData(hour: 5, value: 10),ChartData(hour: 6, value: 110), ChartData(hour: 08, value: 20)], timeTotalInMinutes: 02, timeBreakInMinutes: 10)
            //            viewModel.getInsights { data in
            //                self.insightsData = data
            //            }
        }
        .background(Gradient(colors: [ Color("GradienteBreak"), .black]), ignoresSafeAreaEdges: .all)
        
    }
}

struct TagsInsightsView: View {
    @State var viewModel : InsightsViewModel
    @State private var insightsData: InsightsDataModel?
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Intervalo")
                    .bold()
                    .padding(.horizontal, 10)
            }
            
            if let insights = insightsData {
                HStack{
                    Text("\(self.viewModel.dateFormatter())")
                        .foregroundStyle(Color("TextBreak"))
                        .font(.system(size: 12))
                        .bold()
                        .padding(.horizontal)
                    Spacer()
                }
                
                List(insights.timeFocusedInMinutes, id: \.self) { data in
                    HStack{
                        Circle()
                            .frame(width: 3, height: 3)
                            .foregroundStyle(Color(red: Double(Int.random(in: 0..<255)), green: Double(Int.random(in: 0..<255)), blue: Double(Int.random(in: 0..<255))))
                        Text("\(data.tag)")
                            .font(.system(size: 12))
                            .bold()
                        Spacer()
                        Text("\(viewModel.formatMinutesToHours(minutes: data.value))")
                            .font(.system(size: 12))
                            .bold()
                            .opacity(0.8)
                    }
                }

            } else {
                ProgressView("Carregando...")
            }

        }.onAppear {
            self.insightsData = InsightsDataModel(timeFocusedInMinutes: [TagsData(tag: "teste", value: 100), TagsData(tag: "foi", value: 20), TagsData(tag: "teste", value: 100)], timeFocusedTotal: 20,timeFocusPerHour: [ChartData(hour: 5, value: 10),ChartData(hour: 6, value: 110), ChartData(hour: 08, value: 20)], timeBreakPerHour: [ChartData(hour: 5, value: 10),ChartData(hour: 6, value: 110), ChartData(hour: 08, value: 20)], timeTotalInMinutes: 02, timeBreakInMinutes: 10)
            //            viewModel.getInsights { data in
            //                self.insightsData = data
            //            }
        }
        .background(Gradient(colors: [ Color("GradienteFocus"), .black]), ignoresSafeAreaEdges: .all)
    }
}




#Preview {
    InsightsView()
}
