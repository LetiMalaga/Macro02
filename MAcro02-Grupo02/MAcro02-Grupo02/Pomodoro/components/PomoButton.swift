//
//  PomoButton.swift
//  MAcro02-Grupo02
//
//  Created by Felipe Porto on 09/10/24.
//

import UIKit

class PomoButton: UIButton {

    init(frame: CGRect, titulo: String) {
        super.init(frame: frame)
        self.setTitle(titulo, for: .normal)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: frame.width),
            heightAnchor.constraint(equalToConstant: frame.height)
        ])
        
        print(frame.size)
        
    
        self.layer.cornerRadius = 35
        self.titleLabel?.font = .boldSystemFont(ofSize: 24)
        self.backgroundColor = .black
        self.setTitleColor(.white, for: .normal)
    }

}
