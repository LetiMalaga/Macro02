//
//  InsightsSwiftUIViewController.swift
//  MAcro02-Grupo02
//
//  Created by Letícia Malagutti on 10/10/24.
//

import SwiftUI

class InsightsSwiftUIViewController: UIHostingController<InsightsSwiftUIView> {
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: InsightsSwiftUIView())
    }
    
    init() {
        super.init(rootView: InsightsSwiftUIView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
