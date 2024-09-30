//
//  InsightsPresenter.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 27/09/24.
//

import Foundation

protocol InsightsPresenterProtocol {
    func presentInsights(insights: InsightsData)
}

class InsightsPresenter: InsightsPresenterProtocol {
    private var view: InsightsViewProtocol?
    
    init(view: InsightsViewProtocol) {
        self.view = view
    }
    
    func presentInsights(insights: InsightsData) {
        
    }
    
    
}
