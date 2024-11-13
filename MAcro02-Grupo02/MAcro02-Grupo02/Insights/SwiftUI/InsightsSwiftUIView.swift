//
//  InsightsSwiftUIView.swift
//  MAcro02-Grupo02
//
//  Created by Letícia Malagutti on 10/10/24.
//

import SwiftUI
import Charts

struct InsightsSwiftUIView: View {
    
    var interactor:InsightsInteractorProtocol?
    @ObservedObject var data: InsightsDataView
    var timeFrame = [NSLocalizedString("Dia", comment: "Insights"), NSLocalizedString("Semana", comment: "Insights"), NSLocalizedString("Mês", comment: "Insights")]
    @State private var selectedTimeFrame: String = NSLocalizedString("Dia", comment: "Insights")
    
    var body: some View {
        VStack(spacing: 20){
            Picker("TimeFrameSegmentControl", selection: $selectedTimeFrame) {
                ForEach(timeFrame, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedTimeFrame){
                switch selectedTimeFrame {
                case NSLocalizedString("Dia", comment: "Insights"):
                    interactor?.insightsPerDay()
                    print("insightsPerDay")
                case NSLocalizedString("Semana", comment: "Insights"):
                    interactor?.insightsPerWeek()
                    print("insightsPerWeek")
                case NSLocalizedString("Mês", comment: "Insights"):
                    interactor?.insightsPerMonth()
                    print("insightsPerMonth")
                default:
                    print("erro")
                }
            }
            
//            HStack{
//                Button{
//                    
//                } label: {
//                    Image(systemName: "chevron.left")
//                        .font(.headline)
//                        .fontWeight(.bold)
//                        .foregroundStyle(.black)
//                }
//                
//                Spacer()
//                
//                HStack{
//                    Text("Hoje")
//                        .font(.headline)
//                        .fontWeight(.bold)
//                    
//                    Button {
//                        switch selectedTimeFrame {
//                        case NSLocalizedString("Dia", comment: "Insights"):
//                            interactor?.insightsPerDay()
//                            print("insightsPerDay")
//                        case NSLocalizedString("Semana", comment: "Insights"):
//                            interactor?.insightsPerWeek()
//                            print("insightsPerWeek")
//                        case NSLocalizedString("Mês", comment: "Insights"):
//                            interactor?.insightsPerMonth()
//                            print("insightsPerMonth")
//                        default:
//                            print("erro")
//                        }
//                    } label: {
//                        Text(NSLocalizedString("Refrescar", comment: "Insights"))
//                    }
//                    
//                }
//                Spacer()
//                
//                Button{
//                    
//                } label: {
//                    Image(systemName: "chevron.right")
//                        .font(.headline)
//                        .fontWeight(.bold)
//                        .foregroundStyle(.black)
//                }
//                .padding(.vertical)
//            }

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
                        
                        Text(data.foco)
                            .font(.system(size: 64, weight: .bold))
                            .minimumScaleFactor(0.5)
//                        Text("horas")
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
                            
                            Text("\(data.session)")
                            
                            
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
                                
                                Text(data.pause)
                                                                
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
                                
                                Text("\(data.total )")
                                
                                
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
            
            ZStack{
                FocoPorTagChartView(data: data.tags.isEmpty ? [ChartData(type: NSLocalizedString("Estudos", comment: "Insights"), count: 2), ChartData(type: NSLocalizedString("Trabalho", comment: "Insights"), count: 5 ), ChartData(type: NSLocalizedString("Projetos", comment: "Insights"), count: 10), ChartData(type: NSLocalizedString("Outros", comment: "Insights"), count: 1)] : data.tags)
                //                .frame(width: CGFloat(UIScreen.main.bounds.width-40), height: CGFloat(UIScreen.main.bounds.height/3))
                
                if data.session == 0 {
                    RoundedRectangle(cornerRadius: 15)
                    //                            .frame(width: x, height: y)
                        .foregroundStyle(Color(UIColor.customBGColor))
                        .opacity(0.25)
                    
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Resultados")
        .onAppear {
            interactor?.insightsPerDay()
            
        }
        
    }
}


//#Preview {
//    InsightsSwiftUIView()
//}

extension Double {
    public static let bgRectangleTopHeightCtt = 0.15
    public static let bgPauseAndTotalRectanglesHeightCtt = 0.08
    public static let bgPauseAndTotalRectanglesWidthCtt = 0.5
    public static let bgPauseAndTotalRectanglesWidthSubtractionCtt = 25.0
}
