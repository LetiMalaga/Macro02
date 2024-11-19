
//  ActivityDetailViewController.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 12/11/24.
//

import Foundation
import UIKit

class ActivityDetailViewController: UIViewController{
    
    // MARK: - Properties
    var activity: ActivitiesModel?
    var onSave: ((ActivitiesModel) -> Void)?
    var isEditingActivity: Bool = false
    var interactor: SettingsIteractorProtocol?
    let characterLimit = 100
    
    var tags: [String] = []{
        didSet {tagsCollectionView.dataSource = self}
    }
    
    private var selectedTag: String?
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    let tagLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = AppColors.progressPrimary
        label.backgroundColor = .systemGray
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        label.textAlignment = .center
        label.padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        return label
    }()
    
    private let activityDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Descrição de Atividade", comment: "NewActivityViewController")
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
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
    
    private let saveEditButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Editar", comment: "NewActivityViewController"), for: .normal)
        button.addTarget(self, action: #selector(saveEditButtonTapped), for: .touchUpInside)
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
    
    private let descriptionBackgroundView: UIView = {
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
        view.backgroundColor = AppColors.backgroundPrimary
        title = "Detalhes da Atividade"
        
        setupUIEditing()
        loadActivityData()
        tagsCollectionView.dataSource = self
        tagsCollectionView.delegate = self
        descriptionTextField.delegate = self
    }
    
    // MARK: - UI Setup
    private func setupUISave() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionTextField)
        view.addSubview(tagsBackgroundView)
        tagsBackgroundView.addSubview(tagsCollectionView)
        view.addSubview(tagsDescriptionLabel)
        view.addSubview(backButton)
        view.addSubview(saveEditButton)
        view.addSubview(characterLimitLabel)
        
        // Configuração de Constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        tagsBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        tagsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tagsDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        saveEditButton.translatesAutoresizingMaskIntoConstraints = false
        characterLimitLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            saveEditButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveEditButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            descriptionTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 40),
            
            tagsBackgroundView.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 20),
            tagsBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagsBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tagsBackgroundView.heightAnchor.constraint(equalToConstant: 55),
            
            tagsCollectionView.centerYAnchor.constraint(equalTo: tagsBackgroundView.centerYAnchor),
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
    
    func setupUIEditing(){
        view.addSubview(descriptionBackgroundView)
        descriptionBackgroundView.addSubview(activityDescriptionLabel)
        descriptionBackgroundView.addSubview(tagLabel)
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        view.addSubview(saveEditButton)
        
        tagLabel.text = activity?.tag
        activityDescriptionLabel.text = activity?.description
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        activityDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        saveEditButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            saveEditButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveEditButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            descriptionBackgroundView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 36),
            descriptionBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionBackgroundView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            activityDescriptionLabel.topAnchor.constraint(equalTo: descriptionBackgroundView.topAnchor, constant: 10),
            activityDescriptionLabel.leadingAnchor.constraint(equalTo: descriptionBackgroundView.leadingAnchor, constant: 10),
            activityDescriptionLabel.trailingAnchor.constraint(equalTo: descriptionBackgroundView.trailingAnchor, constant: -10),
            activityDescriptionLabel.heightAnchor.constraint(equalToConstant: 40),
            
            tagLabel.topAnchor.constraint(equalTo: activityDescriptionLabel.bottomAnchor, constant: 10),
            tagLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50), // largura mínima
            tagLabel.heightAnchor.constraint(equalToConstant: 24),
            tagLabel.centerXAnchor.constraint(equalTo: descriptionBackgroundView.centerXAnchor),
        ])
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func loadActivityData() {
        descriptionTextField.text = activity?.description
        selectedTag = activity?.tag
    }
    
    @objc private func saveEditButtonTapped() {
        
        if isEditingActivity{
            let activityDescription = descriptionTextField.text
            guard let activityDescription,
                  var activity = activity else { return }
            activity.description = activityDescription
            activity.tag = selectedTag!
            
            if !interactor!.validateActivityName(activity, .edit) {
                showAlert(with: "Error", message: "Activity description already exists or is empty")
            }else{
                onSave?(activity)
                navigationController?.popViewController(animated: true)
                
            }
            
            dismiss(animated: true, completion: nil)
        }else{
            saveEditButton.setTitle("Save", for: .normal)
            isEditingActivity = true
            selectedTag = activity?.tag
            view.subviews.forEach { $0.removeFromSuperview() }
            setupUISave()
        }
    }
    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


// MARK: - UICollectionView DataSource & Delegate
extension ActivityDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as? TagCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: tags[indexPath.item])
        if tags[indexPath.item] == selectedTag{
            cell.setSelectedTagColor()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTag = tags[indexPath.item]
        print("Tag selecionada: \(selectedTag ?? "")")
    }
}

// MARK: - UITextFieldDelegate
extension ActivityDetailViewController: UITextFieldDelegate {
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

#Preview {
    ActivityDetailViewController()
}
