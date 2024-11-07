//
//  SwitchCell.swift
//  MAcro02-Grupo02
//
//  Created by Felipe Porto on 07/11/24.
//

import UIKit

class SwitchCell: UITableViewCell {
    
    private var funcao: () -> Void


    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let toggleSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = .brown // Cor do switch quando ligado
        switchControl.tintColor = .gray // Cor quando desligado
        return switchControl
    }()
    
    init(titulo: String, funcao: @escaping () -> Void) {
        
        self.funcao = funcao
        
        super.init(style: .default, reuseIdentifier: "SwitchButton")
        
        titleLabel.text = titulo
        toggleSwitch.addTarget(nil, action: #selector(switchToggled), for: .valueChanged)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggleSwitch)
        backgroundColor = .white
        
        NSLayoutConstraint.activate([
            
            
            // pos x dos itens
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // pos y dos itens
            
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            
            
        ])
    }
    
    @objc private func switchToggled() {
        funcao()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
