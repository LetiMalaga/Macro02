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
        ScrollView{
            
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
                
                HStack{
                    Button{
                        switch selectedTimeFrame {
                        case NSLocalizedString("Dia", comment: "Insights"):
                            interactor?.rewindDay()
                        case NSLocalizedString("Semana", comment: "Insights"):
                            interactor?.rewindWeek()
                        case NSLocalizedString("Mês", comment: "Insights"):
                            interactor?.rewindMonth()
                        default:
                            print("erro")
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                    
                    HStack{
                        Text(self.data.textDescriptionDate)
                            .font(.headline)
                            .fontWeight(.bold)
                        
                    }
                    
                    Spacer()
                    
                    Button{
                        switch selectedTimeFrame {
                        case NSLocalizedString("Dia", comment: "Insights"):
                            interactor?.advanceDay()
                        case NSLocalizedString("Semana", comment: "Insights"):
                            interactor?.advanceWeek()
                        case NSLocalizedString("Mês", comment: "Insights"):
                            interactor?.advanceMonth()
                        default:
                            print("erro")
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                    }
                    .padding(.vertical)
                }
                
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
                            if data.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(1.5) // Tamanho da animação
                                    .padding()
                            }else{
                                Text(data.foco)
                                    .font(.system(size: 64, weight: .bold))
                                    .minimumScaleFactor(0.5)
                            }
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
                                if data.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .scaleEffect(1.5) // Tamanho da animação
                                        .padding()
                                }else{
                                    Text("\(data.session)")
                                        .font(.system(size: 64, weight: .bold))
                                        .minimumScaleFactor(0.5)
                                }
                                
                                
                                
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
                                        .minimumScaleFactor(0.3)
                                    Spacer()
                                }
                                HStack{
                                    if data.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle())
                                        //                                            .scaleEffect(1.5) // Tamanho da animação
                                        //                                            .padding()
                                    }else{
                                        Text(data.pause)
                                            .font(.title2)
                                            .minimumScaleFactor(0.5)
                                            .bold()
                                    }
                                    
                                    Spacer()
                                }
                            }
                            Spacer()
                            Image(data.faceIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(height: UIScreen.main.bounds.height * .bgPauseAndTotalRectanglesHeightCtt)
                                .padding(5)
                                .minimumScaleFactor(0.3)
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
                                        .minimumScaleFactor(0.3)
                                    Spacer()
                                }
                                HStack{
                                    if data.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle())
                                        //                                            .scaleEffect(1.5) // Tamanho da animação
                                        //                                            .padding()
                                    }else{
                                        Text("\(data.total )")
                                            .font(.title2)
                                            .minimumScaleFactor(0.5)
                                            .bold()
                                            .padding(5)
                                    }
                                    
                                    Spacer()
                                }
                            }
                            Spacer()
                            Image(data.faceIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(height: UIScreen.main.bounds.height * .bgPauseAndTotalRectanglesHeightCtt)
                                .padding(5)
                                .minimumScaleFactor(0.3)
                        }
                        .padding(8)
                        .scaledToFill()
                    }
                    .frame(width: (UIScreen.main.bounds.width * .bgPauseAndTotalRectanglesWidthCtt - .bgPauseAndTotalRectanglesWidthSubtractionCtt), height: UIScreen.main.bounds.height * .bgPauseAndTotalRectanglesHeightCtt)
                    
                }
                
                ZStack{
                    if data.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5) // Tamanho da animação
                            .padding()
                    }else{
                        FocoPorTagChartView(data: data.tags.isEmpty ? [ChartData(type: NSLocalizedString("Estudos", comment: "Insights"), count: 2), ChartData(type: NSLocalizedString("Trabalho", comment: "Insights"), count: 5 ), ChartData(type: NSLocalizedString("Projetos", comment: "Insights"), count: 10), ChartData(type: NSLocalizedString("Outros", comment: "Insights"), count: 1)] : data.tags)
                    }
                    if data.session == 0 {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(Color(UIColor.customBGColor))
                            .opacity(0.25)
                        
                    }
                }
                .shadow(radius: 5)
                Spacer()
            }
            .padding()
            .navigationTitle("Resultados")
            
            .onAppear {
                interactor?.insightsPerDay()
                
            }
            .overlay {
                if data.showConnectionError {
                    ZStack{
                        Rectangle()
                            .foregroundStyle(.black)
                            .opacity(0.5)
                            .ignoresSafeArea()
                        FailNetworkAlert(interactor: self.interactor)
                    }
                }
            }
        }
        
        
    }
    
    struct FailNetworkAlert: View {
        @State private var countdown = 5 // Valor inicial do contador
        @State private var timerActive = true
        var interactor:InsightsInteractorProtocol?
        var body: some View {
            RoundedRectangle(cornerRadius: 15)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.25)
                .foregroundStyle(.white)
                .overlay {
                    VStack{
                        Text("Ops! Cadê o Wi-Fi?!")
                            .font(.title3)
                            .bold()
                            .padding()
                        Text("Conecte-se à internet para voltar a ver os resultados!")
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                        Spacer()
                        Text("Atualizando em \(self.countdown) segundos...")
                            .foregroundStyle(.gray)
                            .padding()
                    }
                }.onAppear {
                    startCountdown()
                }
        }
        func startCountdown() {
            countdown = 5
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if countdown > 0 {
                    countdown -= 1
                } else {
                    timer.invalidate()
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0)) {
                        interactor?.insightsPerDay()
                        startCountdown()
                    }
                }
            }
        }
    }
}


#Preview {
    InsightsSwiftUIView(interactor: nil, data: InsightsDataView())
    //    FailNetworkAlert()
}

extension Double {
    public static let bgRectangleTopHeightCtt = 0.15
    public static let bgPauseAndTotalRectanglesHeightCtt = 0.08
    public static let bgPauseAndTotalRectanglesWidthCtt = 0.5
    public static let bgPauseAndTotalRectanglesWidthSubtractionCtt = 25.0
}
