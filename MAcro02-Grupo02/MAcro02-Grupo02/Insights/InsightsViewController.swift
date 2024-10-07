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
    let pr
}

extension InsightsViewController: InsightsViewProtocol, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let item = "test"
        cell.textLabel?.text = item
        return cell
    }
    
    
}
