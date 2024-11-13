//
//  Colors.swift
//  MAcro02-Grupo02
//
//  Created by Felipe Porto on 01/11/24.
//

import UIKit

// Fontes

struct AppFonts {
    static let largeTitle = UIFont.systemFont(ofSize: 34)
    static let title1 = UIFont.systemFont(ofSize: 28)
    static let title2 = UIFont.systemFont(ofSize: 22)
    static let regular = UIFont.systemFont(ofSize: 13)
}

// Cores

//struct AppColors {
//    
//    static let backgroundPrimary = UIColor { traitCollection in
//        return traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
//    }
//
//    static let textPrimary = UIColor { traitCollection in
//        return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
//    }
//    
//    static let progressPrimary = UIColor.systemGray6
//    
//    static let progressSecundary = UIColor { traitCollection in
//        return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
//    }
//}

extension UIFont {
    func bold() -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(.traitBold) else { return self }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
