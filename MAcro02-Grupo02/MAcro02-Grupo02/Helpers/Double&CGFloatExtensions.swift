//
//  Double&CGFloatExtensions.swift
//  MAcro02-Grupo02
//
//  Created by Letícia Malagutti on 01/11/24.
//

import Foundation

// MARK: Extensões para manter o app proporcional em todos os dispositivos
extension Double {
    public static let modalIdentifierLineWidthCtt = 0.23
    public static let modalIdentifierLineHeightCtt = 0.01
    
    public static let ellipsisButtonWidthCtt = 0.07
    public static let ellipsisButtonHeightCtt = 0.03
    
    public static let removeButtonWidthCtt = 0.06
    public static let removeButtonHeightCtt = 0.03
}

extension CGFloat {
    public static let modalIdentifierLineCornerRadius = 5.00
    
    public static let tagCornerRadius = 25.0
    public static let activityCornerRadius = 10.0
    
    public static let tagWidthCtt = 0.36
    public static let tagHeightCtt = 0.06 // altura 0.06 -> valor dividido pelo tamanho de tela total
    public static let tagHeightCttModal = 0.43 // 0.43 -> tamanho dividido pela altura, que está correta
}


