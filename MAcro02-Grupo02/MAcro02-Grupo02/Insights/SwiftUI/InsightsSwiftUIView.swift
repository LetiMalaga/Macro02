//
//  InsightsSwiftUIView.swift
//  MAcro02-Grupo02
//
//  Created by Letícia Malagutti on 10/10/24.
//

import SwiftUI
import Charts

struct InsightsSwiftUIView: View {
    var timeFrame = ["Dia", "Semana", "Mês"]
    @State private var selectedTimeFrame: String = "Dia"
    
    var body: some View {
        VStack(spacing: 20){
            Picker("TimeFrameSegmentControl", selection: $selectedTimeFrame) {
                ForEach(timeFrame, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            
            HStack{
                Button{
                    
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                Text("Hoje")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button{
                    
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                }
                .padding(.vertical)
                
                // Retângulo foco
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(Color(UIColor.systemGray4))
                    
                    VStack{
                        HStack{
                            Text("Foco")
                                .font(.title)
                                .bold()
                                .minimumScaleFactor(0.5)
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack(alignment: .bottom){
                            Text(String(Date().formatted(date: .omitted, time: .shortened)))
                                .font(.system(size: 64, weight: .bold))
                                .minimumScaleFactor(0.5)
                            Text("Horas")
                                .minimumScaleFactor(0.5)
                            Spacer()
                        }
                        
                    }
                    .padding()
                    
                    // Quadrado sessões
                    HStack{
                        Spacer()
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(Color(UIColor.systemGray2))
                            VStack{
                                Text("Sessões")
                                    .font(.caption2)
                                    .bold()
                                    .minimumScaleFactor(0.5)
                                Spacer()
                                Text("3")
                                    .font(.system(size: 64, weight: .bold))
                                    .minimumScaleFactor(0.5)
                                Spacer()
                            }
                            .padding(8)
                        }
                        .frame(width: (UIScreen.main.bounds.height * .bgRectangleTopHeightCtt - 16))
                        .padding(8)
                    }
                }
                .frame(height: UIScreen.main.bounds.height * .bgRectangleTopHeightCtt)
                
                HStack(spacing: 20){
                    // Retângulo Pausa
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(Color(UIColor.systemGray4))
                        HStack{
                            VStack{
                                HStack{
                                    Text("Pausa")
                                        .font(.title3)
                                        .bold()
                                        .minimumScaleFactor(0.5)
                                    Spacer()
                                }
                                HStack{
                                    Text("10m")
                                        .font(.title)
                                        .bold()
                                        .minimumScaleFactor(0.5)
                                    Spacer()
                                }
                            }
                            Spacer()
                            Image(systemName: "face.smiling")
                                .font(.system(size: 50))
                                .minimumScaleFactor(0.5)
                        }
                        .padding(8)
                        .scaledToFill()
                    }
                    .frame(width: (UIScreen.main.bounds.width * .bgPauseAndTotalRectanglesWidthCtt - .bgPauseAndTotalRectanglesWidthSubtractionCtt), height: UIScreen.main.bounds.height * .bgPauseAndTotalRectanglesHeightCtt)
                    
                    // Retângulo Total
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(Color(UIColor.systemGray4))
                        HStack{
                            VStack{
                                HStack{
                                    Text("Total")
                                        .font(.title3)
                                        .bold()
                                        .minimumScaleFactor(0.5)
                                    Spacer()
                                }
                                HStack{
                                    Text("2:30h")
                                        .font(.title)
                                        .bold()
                                        .minimumScaleFactor(0.5)
                                    Spacer()
                                }
                            }
                            Spacer()
                            Image(systemName: "face.smiling")
                                .font(.system(size: 50))
                                .minimumScaleFactor(0.5)
                        }
                        .padding(8)
                        .scaledToFill()
                    }
                    .frame(width: (UIScreen.main.bounds.width * .bgPauseAndTotalRectanglesWidthCtt - .bgPauseAndTotalRectanglesWidthSubtractionCtt), height: UIScreen.main.bounds.height * .bgPauseAndTotalRectanglesHeightCtt)
                }
                
                FocoPorTagChartView()
                //                .frame(width: CGFloat(UIScreen.main.bounds.width-40), height: CGFloat(UIScreen.main.bounds.height/3))
                Spacer()
            }
            .padding()
            .navigationTitle("Resultados")
        }
    }
}


#Preview {
    InsightsSwiftUIView()
}

extension Double {
    public static let bgRectangleTopHeightCtt = 0.15
    public static let bgPauseAndTotalRectanglesHeightCtt = 0.08
    public static let bgPauseAndTotalRectanglesWidthCtt = 0.5
    public static let bgPauseAndTotalRectanglesWidthSubtractionCtt = 25.0
}
