////
////  ColorExtensions.swift
////  MAcro02-Grupo02
////
////  Created by Letícia Malagutti on 12/11/24.
////
//
//import Foundation
//import SwiftUI
//
//extension Color {
//    // Inicializador para suportar cores adaptáveis no modo claro/escuro
//    init(lightHex: UInt, darkHex: UInt) {
//        self = Color {
//            UITraitCollection.current.userInterfaceStyle == .dark ? Color(rgb: darkHex) : Color(rgb: lightHex)
//        }
//    }
//
//    // Inicializador auxiliar para criar `Color` a partir de valores HEX
//    init(rgb: UInt) {
//        self = Color(
//            .sRGB,
//            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
//            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
//            blue: Double(rgb & 0x0000FF) / 255.0,
//            opacity: 1.0
//        )
//    }
//}
//
///* MARK: Modo de usar
//let adaptiveBackgroundColor = Color(lightHex: 0xFAF8F6, darkHex: 0x1A1A1A)
//*/
//
//extension Color {
//    // Padrões
//    static let customBGColor = Color(lightHex: 0xFAF8F6, darkHex: 0x141414)
//    static let customAccentColor = Color(lightHex: 0xAA603C, darkHex: 0xFF830F)
//    
//    // Círculo
//    static let customCircleColor = Color(lightHex: 0xF3E9E3, darkHex: 0x2F2012)
//    static let customInnerCircleColor = Color(lightHex: 0xC5A494, darkHex: 0xEFB37A)
//    
//    // Botão Personalização
//    static let customPersonalizationButtonColor = Color(lightHex: 0xF3E9E3, darkHex: 0x2F2012)
//    static let customPersonalizationButtonStrokeColor = Color(lightHex: 0xC5A494, darkHex: 0xEFB37A)
//    
//    // Textos
//    static let customText = Color(lightHex: 0x333333, darkHex: 0xE4E4E4)
//    static let customTextOpposite = Color(lightHex: 0xE4E4E4, darkHex: 0x333333)
//    static let customTextGray = Color(lightHex: 0x9BA0AA, darkHex: 0x7E7E7E)
//}
