//
//  InsightsSwiftUIViewController.swift
//  MAcro02-Grupo02
//
//  Created by Letícia Malagutti on 10/10/24.
//

import SwiftUI

class InsightsSwiftUIViewController: UIHostingController<InsightsSwiftUIView> , InsightsViewProtocol{
    var interactor:InsightsInteractorProtocol!
    var data: InsightsDataView?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: InsightsSwiftUIView())
    }
    

    init(interactor: InsightsInteractorProtocol?) {
        super.init(rootView: InsightsSwiftUIView(interactor: interactor))

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

