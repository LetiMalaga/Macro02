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

struct AppColors {
    
    static let backgroundPrimary = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
    }

    static let textPrimary = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
    }
    
    static let progressPrimary = UIColor.systemGray6
    
    static let progressSecundary = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
    }
    
    static let primaryColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor(red: 255/255, green: 151/255, blue: 53/255, alpha: 1) : UIColor(red: 149/255, green: 85/255, blue: 52/255, alpha: 1)
    }
    
    static let secondaryColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor(red: 239/255, green: 179/255, blue: 122/255, alpha: 1) : UIColor(red: 197/255, green: 164/255, blue: 148/255, alpha: 1)
    }
    
    static let fullfilColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor(red: 47/255, green: 32/255, blue: 18/255, alpha: 1) : UIColor(red: 243/255, green: 233/255, blue: 227/255, alpha: 1)
    }
}

extension UIFont {
    func bold() -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(.traitBold) else { return self }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
