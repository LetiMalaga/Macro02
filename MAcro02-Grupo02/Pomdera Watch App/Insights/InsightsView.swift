////
////  InsightsView.swift
////  Pomdera Watch App
////
////  Created by Luiz Felipe on 25/11/24.
////
//
//import SwiftUI
//import Charts
//
//
//struct InsightsView: View {
//    @StateObject private var viewModel = InsightsViewModel()
//    @State private var insightsData: InsightsDataModel?
//
//    var body: some View {
//        VStack {
//            if let insights = insightsData {
//                Text("Insights do Dia")
//                    .font(.headline)
//
//                InsightsChartView(data: insights.timePerHour)
//                
//                Text("Foco Total: \(insights.timeTotalInMinutes) minutos")
//                Text("Intervalo: \(insights.timeBreakInMinutes) minutos")
//            } else {
//                ProgressView("Carregando...")
//            }
//        }
//        .onAppear {
//            viewModel.getInsights { data in
//                self.insightsData = data
//            }
//        }
//    }
//    
//    private var chart: some View {
//        Chart(insightsData?, id: \.day) {
//            BarMark(
//                x: .value("Date", $0.day),
//                y: .value("Sales", $0.sales),
//                width: isOverview ? .automatic : .fixed(barWidth)
//            )
//            .accessibilityLabel($0.day.formatted(date: .complete, time: .omitted))
//            .accessibilityValue("\($0.sales) sold")
//            .accessibilityHidden(isOverview)
//            .foregroundStyle(chartColor.gradient)
//        }
//        .accessibilityChartDescriptor(self)
//        .chartXAxis(isOverview ? .hidden : .automatic)
//        .chartYAxis(isOverview ? .hidden : .automatic)
//        .frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
//    }
//}
//
//struct InsightsChartView: View {
//    let data: [Int: Int] // Dados por hora (hora, minutos focados)
//    
//    var body: some View {
//        GeometryReader { geometry in
//            VStack(alignment: .leading) {
//                // Eixo X (horas)
//                HStack {
//                    ForEach(10..<19) { hour in
//                        Text("\(hour)HR")
//                            .font(.caption2)
//                            .frame(maxWidth: .infinity)
//                    }
//                }
//                
//                // Gráfico de barras
//                HStack(alignment: .bottom, spacing: 4) {
//                    ForEach(10..<19, id: \.self) { hour in
//                        let focusMinutes = data[hour] ?? 0
//                        let maxMinutes = 60 // Assumindo 1 hora como máximo
//                        
//                        Rectangle()
//                            .fill(Color.cyan)
//                            .frame(
//                                height: CGFloat(focusMinutes) / CGFloat(maxMinutes) * geometry.size.height
//                            )
//                    }
//                }
//            }
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    InsightsView()
//}
