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
    let characterLimit = 100
    var tags: [String] = ["teste"] {
        didSet { tagsCollectionView.reloadData() }
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
        textField.placeholder = NSLocalizedString("Descrição de Atividade", comment: "NewActivityViewController")
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 16)
        return textField
    }()
    
    private let characterLimitLabel: UILabel = {
        let label = UILabel()
        label.text = "" // Começa vazia
        label.font = .systemFont(ofSize: 12)
        label.textColor = .red
        label.isHidden = true // Oculta inicialmente
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Voltar", comment: "NewActivityViewController"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Salvar", comment: "NewActivityViewController"), for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.tintColor = .customAccentColor
        button.setTitleColor(.customTextOpposite, for: .normal)
        return button
    }()
    
    private let tagsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: 100, height: 40)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let tagsBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()

    private let tagsDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Escolha uma etiqueta que faça mais sentido para sua atividade", comment: "NewActivityViewController")
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBGColor
        setupUI()
        configureTitle()
        interactor?.fetchTags()
        
        tagsCollectionView.dataSource = self
        tagsCollectionView.delegate = self
        descriptionTextField.delegate = self
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionTextField)
        view.addSubview(tagsBackgroundView)
        tagsBackgroundView.addSubview(tagsCollectionView)
        view.addSubview(tagsDescriptionLabel)
//        tagsBackgroundView.addSubview(tagsDescriptionLabel)
        view.addSubview(backButton)
        view.addSubview(saveButton)
        view.addSubview(characterLimitLabel)
        
        // Configuração de Constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        tagsBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        tagsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tagsDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        characterLimitLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            tagsBackgroundView.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 20),
            tagsBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagsBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tagsBackgroundView.heightAnchor.constraint(equalToConstant: 55),
            
            tagsCollectionView.topAnchor.constraint(equalTo: tagsBackgroundView.topAnchor, constant: 8),
            tagsCollectionView.leadingAnchor.constraint(equalTo: tagsBackgroundView.leadingAnchor, constant: 8),
            tagsCollectionView.trailingAnchor.constraint(equalTo: tagsBackgroundView.trailingAnchor, constant: -8),
            tagsCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            tagsDescriptionLabel.topAnchor.constraint(equalTo: tagsBackgroundView.bottomAnchor, constant: 10),
            tagsDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagsDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            characterLimitLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 4),
            characterLimitLabel.leadingAnchor.constraint(equalTo: descriptionTextField.leadingAnchor),
            characterLimitLabel.trailingAnchor.constraint(equalTo: descriptionTextField.trailingAnchor)
        ])
    }
    
    private func configureTitle() {
        switch activityType {
        case .short:
            titleLabel.text = NSLocalizedString("Nova Atividade Curta", comment: "NewActivityViewController")
        case .long:
            titleLabel.text = NSLocalizedString("Nova Atividade Longa", comment: "NewActivityViewController")
        case .none:
            titleLabel.text = NSLocalizedString("Nova Atividade", comment: "NewActivityViewController")
        }
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        let activityDescription = descriptionTextField.text
        guard let activityType,
              let activityDescription else { return }
        let activity = ActivitiesModel(id: UUID(), type: activityType, description: activityDescription, tag: selectedTag ?? tags.first!, isCSV: false)
        if !interactor!.validateActivityName(activity, .adding) {
            showAlert(with: "Error", message: "Activity description already exists or is empty")
        } else {
            interactor?.addActivity(activity)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension NewActivityViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as? TagCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: tags[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTag = tags[indexPath.item]
        print("Tag selecionada: \(selectedTag ?? "")")
    }
}

// MARK: - UITextFieldDelegate
extension NewActivityViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if updatedText.count > characterLimit {
            characterLimitLabel.text = "Limite de \(characterLimit) caracteres atingido"
            characterLimitLabel.isHidden = false
            return false
        } else {
            characterLimitLabel.isHidden = true
        }
        return true
    }
}

class TagCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "TagCollectionViewCell"
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .systemBlue : .lightGray
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .lightGray
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(tagLabel)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tagLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tagLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tagLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 8),
            tagLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    // MARK: - Configure Cell
    func configure(with tag: String) {
        tagLabel.text = tag
    }
    func setSelectedTagColor(){
        contentView.backgroundColor = .systemBlue
    }
}
#Preview {
    NewActivityViewController()
}
