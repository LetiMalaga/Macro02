//
//  ChartsInsightsDummySwiftUI.swift
//  MAcro02-Grupo02
//
//  Created by Letícia Malagutti on 16/10/24.
//

import SwiftUI
import Charts

struct ChartData: Identifiable {
    var id: String { type }
    var type: String
    var count: Int
}

struct FocoPorTagChartView: View {
    let data:[ChartData]
    
    var body: some View {
        Chart (data) { dataPoint in
            BarMark(x: .value("População", dataPoint.count),
                    y: .value("Tipo", dataPoint.type))
            .foregroundStyle(by: .value("Tipo", dataPoint.type))
            .annotation(position: .trailing) {
                Text(String(dataPoint.count))
                    .foregroundStyle(.gray)
            }
        }
        .chartLegend(.hidden)
//        .chartXAxis(.hidden)
        .frame(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.3)
        .aspectRatio(contentMode: .fit)
        .padding()
        .background(Color(UIColor.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        
    }
}

//struct FocoPorTagChartView: View {
//    var body: some View {
//        Chart {
//            BarMark(x: .value("Type", "bird"),
//                    y: .value("Population", 1))
//
//            BarMark(x: .value("Type", "dog"),
//                    y: .value("Population", 2))
//
//            BarMark(x: .value("Type", "cat"),
//                    y: .value("Population", 3))
//
//            RuleMark(y: .value("Average", 1.5))
//                .foregroundStyle(.gray)
//                .annotation(position: .bottom, alignment: .bottomLeading){
//                    Text("Average 1.5")
//                }
//
//        }
//        .aspectRatio(contentMode: .fit)
//        .padding()
//        .background(Color(UIColor.systemGray5))
//        .clipShape(RoundedRectangle(cornerRadius: 15))
//    }
//}

#Preview{
    FocoPorTagChartView(data: [ChartData(type: "teste", count: 2)])
}
