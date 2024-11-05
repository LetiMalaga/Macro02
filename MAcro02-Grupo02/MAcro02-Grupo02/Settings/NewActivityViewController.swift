//
//  NewActivityViewController.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 01/11/24.
//

import Foundation
import UIKit

class NewActivityViewController: UIViewController {
    
    // MARK: - Properties
    var activityType: ActivitiesType?
    var interactor: SettingsIteractorProtocol?
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Descrição da Atividade"
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 16)
        return textField
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Voltar", for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Salvar", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configureTitle()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionTextField)
        view.addSubview(backButton)
        view.addSubview(saveButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            descriptionTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureTitle() {
        switch activityType {
        case .short:
            titleLabel.text = "Nova Atividade Curta"
        case .long:
            titleLabel.text = "Nova Atividade Longa"
        case .none:
            titleLabel.text = "Nova Atividade"
        }
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        let activityDescription = descriptionTextField.text ?? ""
        guard let activityType else { return }
        interactor?.addActivity(ActivitiesModel(type: activityType, Description: activityDescription))
        
        dismiss(animated: true, completion: nil)
    }
}
#Preview {
    NewActivityViewController()
}
