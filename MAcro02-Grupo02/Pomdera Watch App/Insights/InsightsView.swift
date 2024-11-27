//
//  InsightsView.swift
//  Pomdera Watch App
//
//  Created by Luiz Felipe on 25/11/24.
//

import SwiftUI
import Charts


struct InsightsView: View {
    @State var tested: Bool = true
    @StateObject private var viewModel = InsightsViewModel()
    @State private var insightsData: InsightsDataModel?
    var body: some View {
        TabView {
            if let insights = insightsData {
                FocusInsightsView(viewModel: self.viewModel, insightsData: insights)
                BreakInsightsView(viewModel: self.viewModel, insightsData: insights)
                TagsInsightsView(viewModel: self.viewModel, insightsData: insights)
            }else{
                ProgressView("Carregando...")
            }
        }.tabViewStyle(.verticalPage)
            .onAppear {
                if tested{
                    self.insightsData = InsightsDataModel(timeFocusedInMinutes: [TagsData(tag: "teste", value: 80), TagsData(tag: "foi", value: 20), TagsData(tag: "teste", value: 100)], timeFocusedTotal: 20,timeFocusPerHour: [ChartData(hour: 5, value: 10),ChartData(hour: 6, value: 110), ChartData(hour: 08, value: 20)], timeBreakPerHour: [ChartData(hour: 5, value: 10),ChartData(hour: 6, value: 110), ChartData(hour: 08, value: 20)], timeTotalInMinutes: 02, timeBreakInMinutes: 10)
                }else{
                    viewModel.getInsights { data in
                        self.insightsData = data
                    }
                }
            }
    }
    
    
}

struct FocusInsightsView: View {
    @State var viewModel : InsightsViewModel
    @State var insightsData: InsightsDataModel
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("Foco")
                    .bold()
                    .padding(.horizontal, 10)
                
            }
            Chart(insightsData.timeFocusPerHour, id: \.self) {
                BarMark(
                    x: .value("Date", $0.hour),
                    y: .value("Sales", $0.value),
                    width: insightsData.timeFocusPerHour.count < 5 ? .fixed(10) : .automatic
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
                Text("\(viewModel.formatMinutesToHours(minutes: insightsData.timeFocusedTotal))")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundStyle(.white)
                
                Spacer()
            }.padding(1)
        }
        .background(Gradient(colors: [ Color("GradienteFocus"), .black]), ignoresSafeAreaEdges: .all)
    }
}
struct BreakInsightsView: View {
    @State var viewModel : InsightsViewModel
    @State var insightsData: InsightsDataModel
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Text("Intervalo")
                    .bold()
                    .padding(.horizontal, 10)
                
            }
            Chart(insightsData.timeBreakPerHour, id: \.self) {
                BarMark(
                    x: .value("Date", $0.hour),
                    y: .value("Sales", $0.value),
                    width: insightsData.timeBreakPerHour.count < 5 ? .fixed(10) : .automatic
                    
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
                Text("\(viewModel.formatMinutesToHours(minutes: insightsData.timeBreakInMinutes))")
                    .font(.system(size: 20))
                    .bold()
                Spacer()
            }.padding(1)
        }
        .background(Gradient(colors: [ Color("GradienteBreak"), .black]), ignoresSafeAreaEdges: .all)
        
    }
}

struct TagsInsightsView: View {
    @State var viewModel : InsightsViewModel
    @State var insightsData: InsightsDataModel
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Etiquetas")
                    .bold()
                    .padding(.horizontal, 10)
            }
            
            HStack{
                Text("\(self.viewModel.dateFormatter())")
                    .foregroundStyle(Color("TextTag"))
                    .font(.system(size: 20))
                    .bold()
                    .padding(.horizontal)
                Spacer()
            }
            
            List(insightsData.timeFocusedInMinutes, id: \.self) { data in
                HStack{
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
        }
        .background(Gradient(colors: [ Color("GradienteTag"), .black]), ignoresSafeAreaEdges: .all)
    }
}




#Preview {
    InsightsView()
}
