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
        label.text = NSLocalizedString("Trabalho", comment: "ModalTagsData")
        label.font = UIFont(name: "Baloo2-Bold", size: 24)
        label.textColor = UIColor.customText
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
        
        layer.borderColor = UIColor.customPersonalizationButtonStrokeColor.cgColor
        
        tagline.layer.cornerRadius = .tagCornerRadius
        tagline.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMinYCorner,
            .layerMaxXMaxYCorner
        ]
        
        NSLayoutConstraint.activate([
            tagline.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            tagline.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.heightAnchor.constraint(equalToConstant: 47),
            self.widthAnchor.constraint(equalToConstant: 132)
        ])
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
    }
}
