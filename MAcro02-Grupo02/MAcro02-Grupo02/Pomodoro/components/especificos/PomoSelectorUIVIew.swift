//
//  PomoSelectorUIVIew.swift
//  MAcro02-Grupo02
//
//  Created by Felipe Porto on 13/11/24.
//

import UIKit

class PomoSelectorUIVIew: UIView {

    var NumText:String {
        didSet {
            NumLabel.text = NumText
        }
    }
    
    private let backgroundView: UIView = {
        
        let view = UIView()
        
        view.layer.borderColor = UIColor.customPersonalizationButtonStrokeColor.cgColor
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 3
        view.backgroundColor = UIColor.customPersonalizationButtonColor

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    private let NumLabel: InsetLabel = {
        let label = InsetLabel()
        label.textColor = UIColor.customText
        label.backgroundColor = .clear
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Baloo2-Bold", size: 70)
        return label
    }()
    
    private let ChevronImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = UIColor.customAccentColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: 2).isActive = true
        view.backgroundColor = UIColor.customPersonalizationButtonStrokeColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(NumText: String) {
        self.NumText = NumText
        
        super.init(frame: .zero)
        
        NumLabel.text = NumText
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        addSubview(backgroundView)
        addSubview(NumLabel)
        addSubview(ChevronImage)
        addSubview(line)
        
        NSLayoutConstraint.activate([
            
            widthAnchor.constraint(equalToConstant: 261),
            heightAnchor.constraint(equalToConstant: 80),
            
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            NumLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            NumLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -45),
            NumLabel.widthAnchor.constraint(equalTo: widthAnchor),
            
            line.trailingAnchor.constraint(equalTo: ChevronImage.leadingAnchor, constant: -10),
            line.heightAnchor.constraint(equalToConstant: 80),
            
            ChevronImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            ChevronImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
        ])
        
        
        
    }
    
    
    
}

class InsetLabel: UILabel {
    var textInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0) // Ajuste a quantidade para o valor desejado

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}
