//
//  TagFrame.swift
//  MAcro02-Grupo02
//
//  Created by Felipe Porto on 09/10/24.
//

import UIKit

class TagFrame: UIView {
    
    lazy var tagline:UILabel = {
        
        let label = UILabel()
        label.text = "Trabalho"
        label.font = .systemFont(ofSize: 26)
        label.textColor = .systemOpposingColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    lazy var local:UILabel = {
        
        let label = UILabel()
        label.text = "Em casa"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemOpposingColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTag() {
        addSubview(tagline)
        addSubview(local)
        
        layer.borderColor = UIColor.black.cgColor
        
        NSLayoutConstraint.activate([   
            tagline.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            tagline.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 1),
            local.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            local.topAnchor.constraint(equalTo: tagline.bottomAnchor, constant: -5),
            
            self.heightAnchor.constraint(equalToConstant: 47),
            self.widthAnchor.constraint(equalToConstant: 132)
        ])
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
    }
}
