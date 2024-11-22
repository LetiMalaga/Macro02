//
//  ColorExtensions.swift
//  MAcro02-Grupo02
//
//  Created by Letícia Malagutti on 12/11/24.
//

import Foundation
import UIKit


extension UIColor {
    // Unified initializer for HEX values with light/dark mode adaptation
    convenience init(lightHex: UInt, darkHex: UInt) {
        self.init { traitCollection in
            let hex = traitCollection.userInterfaceStyle == .dark ? darkHex : lightHex
            return UIColor(rgb: hex)
        }
    }

    // Helper initializer for creating UIColor from a single HEX value
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}

/* MARK: Modo de usar
let adaptiveBackgroundColor = UIColor(lightHex: 0xFAF8F6, darkHex: 0x1A1A1A)
*/

extension UIColor {
    // Padrões
    static let customBGColor = UIColor(lightHex: 0xFAF8F6, darkHex: 0x141414)
    static let customAccentColor = UIColor(lightHex: 0xAA603C, darkHex: 0xFF830F)
    static let customLightAccentColor = UIColor(lightHex: 0xF3E9E3, darkHex: 0x2F2012)
    static let customMediumAccentColor = UIColor(lightHex: 0xC5A494, darkHex: 0xEFB37A)
    
    
    // Círculo
    static let customCircleColor = UIColor(lightHex: 0xF3E9E3, darkHex: 0x2F2012)
    static let customInnerCircleColor = UIColor(lightHex: 0xC5A494, darkHex: 0xEFB37A)
    
    // Botão Personalização
    static let customPersonalizationButtonColor = UIColor(lightHex: 0xF3E9E3, darkHex: 0x2F2012)
    static let customPersonalizationButtonStrokeColor = UIColor(lightHex: 0xC5A494, darkHex: 0xEFB37A)
    
    // Textos
    static let customText = UIColor(lightHex: 0x333333, darkHex: 0xE4E4E4)
    static let customTextOpposite = UIColor(lightHex: 0xE4E4E4, darkHex: 0x333333)
    static let customTextGray = UIColor(lightHex: 0x9BA0AA, darkHex: 0x7E7E7E)
}
