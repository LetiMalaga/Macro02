//
//  InsightsSwiftUIViewController.swift
//  MAcro02-Grupo02
//
//  Created by Letícia Malagutti on 10/10/24.
//

import SwiftUI

class InsightsSwiftUIViewController: UIHostingController<InsightsSwiftUIView> {
    var interactor:InsightsInteractorProtocol?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: InsightsSwiftUIView(interactor: interactor))
    }
    
    init() {
        super.init(rootView: InsightsSwiftUIView(interactor: interactor))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
