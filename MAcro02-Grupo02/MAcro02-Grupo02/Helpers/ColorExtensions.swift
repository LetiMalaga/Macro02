//
//  ColorExtensions.swift
//  MAcro02-Grupo02
//
//  Created by Letícia Malagutti on 12/11/24.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(rgb: UInt) {
           self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
        }
    
    static var teste = UIColor.init(rgb: 0xF58634)
}
/* MARK: Modo de usar
  view.backgroundColor = UIColor.init(rgb: 0xF58634)
 */
