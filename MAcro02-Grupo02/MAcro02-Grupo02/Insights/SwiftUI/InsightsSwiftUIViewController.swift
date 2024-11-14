//
//  InsightsSwiftUIViewController.swift
//  MAcro02-Grupo02
//
//  Created by Letícia Malagutti on 10/10/24.
//

import SwiftUI
import Foundation

protocol InsightsViewProtocol: AnyObject {
    var data: InsightsDataView {get set}
}

class InsightsDataView: ObservableObject{
    @Published var isLoading: Bool = false
    @Published var foco: String = "0"
    @Published var session: Int = 0
    @Published var pause: String = "0"
    @Published var total: String = "0"
    @Published var tags: [ChartData] = []
    @Published var textDescriptionDate: String = "Hoje"
    @Published var faceIcon: String = ""
    @Published var showConnectionError: Bool = true

}

class InsightsSwiftUIViewController: UIHostingController<InsightsSwiftUIView> , InsightsViewProtocol{
    var interactor:InsightsInteractorProtocol!
    var data: InsightsDataView = InsightsDataView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: InsightsSwiftUIView(data: data))
    }
    

    init(interactor: InsightsInteractorProtocol?) {
        super.init(rootView: InsightsSwiftUIView(interactor: interactor, data: data))

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

