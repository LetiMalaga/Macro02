//
//  PredefinitionButtonsView.swift
//  MAcro02-Grupo02
//
//  Created by Felipe Porto on 28/10/24.
//

import UIKit

class PredefinitionButtonsView: UIView {
    
    var buttons: [UIButton] = []
    var buttonAction: ((Int) -> Void)?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        
        self.layer.borderColor = UIColor.customPersonalizationButtonStrokeColor.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 20
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
    }
    
    private func setupStackView() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    func setupButtons(with values: [Int]) {
        // Remover botões antigos
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        
        // Criar novos botões com os valores do array
        for value in values {
            let button = UIButton(type: .system)
            button.setTitle("\(value)", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            button.layer.cornerRadius = 13
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor.customPersonalizationButtonStrokeColor.cgColor
            button.setTitleColor(.customText, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        if let title = sender.title(for: .normal) {
            buttonAction?(Int(title) ?? 0)
            if UserDefaults.standard.bool(forKey: "sound"){
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            }
        }
    }
}
