//
//  NewActivityViewController.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 01/11/24.
//

import Foundation
import UIKit


class NewActivityViewController: UIViewController{
    
    
    
    // MARK: - Properties
    var activityType: ActivitiesType?
    var interactor: SettingsIteractorProtocol?
    var tags: [String] = []{
        didSet {tagPickerView.dataSource = self}
    }
    private var selectedTag: String?
    
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
    
    private let tagPickerView = UIPickerView()
    
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
    
    private let tagContainerStackView: UIStackView = {
        let label = UILabel()
        label.text = "Selecione uma Tag"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .darkGray
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [label, separatorView])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configureTitle()
        
        tagPickerView.dataSource = self
        tagPickerView.delegate = self
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionTextField)
        view.addSubview(tagContainerStackView)
        view.addSubview(tagPickerView)
        view.addSubview(backButton)
        view.addSubview(saveButton)
        
        // Configuração de Constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        tagContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        tagPickerView.translatesAutoresizingMaskIntoConstraints = false
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
            descriptionTextField.heightAnchor.constraint(equalToConstant: 40),
            
            tagContainerStackView.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 20),
            tagContainerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagContainerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tagPickerView.topAnchor.constraint(equalTo: tagContainerStackView.bottomAnchor, constant: 8),
            tagPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tagPickerView.heightAnchor.constraint(equalToConstant: 100)
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
        let tag = selectedTag ?? "Sem Tag"
        
        interactor?.addActivity(ActivitiesModel(type: activityType, description: activityDescription, tag: tag))
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIPickerView DataSource & Delegate
extension NewActivityViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tags.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tags[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTag = tags[row]
    }
}
#Preview {
    NewActivityViewController()
}