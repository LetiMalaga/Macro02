//
//  InsightsViewModel.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 30/09/24.
//

import Foundation
import UIKit

protocol InsightsViewProtocol: AnyObject {
    
}

class InsightsViewController: UIViewController {
    var interactor:InsightsInteractorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension InsightsViewController: InsightsViewProtocol{
    
    
    
}
