//
//  SheetViewController.swift
//  MAcro02-Grupo02
//
//  Created by Letícia Malagutti on 22/10/24.
//

// Tela já com proporções corretas

import UIKit


protocol PassingTag{
    func passing(_ tag:String)
}

protocol SheetViewControllerProtocol: AnyObject {
    var tags: [String] { get set }

    func showAlert(with title: String, message: String)
}

class SheetViewController: UIViewController, SheetViewControllerProtocol {
    var tags: [String] = [] {
        didSet {collectionView.reloadData()}
    }
    private var selectedTag:String?
    // MARK: Variables
    private let modalIdentifierLine = UIView()
    private let modalTagLabel = UILabel()
    private let tagNewTagButton = UIButton(type: .system)
    private var isEditingMode: Bool = false
    private var isAddingNewTag: Bool = false
    var delegate: PassingTag?

    public var interactor:ModalTagsInteractorProtocol?
//    var tags: [String] = []
    var arraybuttons: [UIButton] = []

    // MARK: UI Components

    private let textFieldTag: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Adicionar Tag"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemBackground
        textField.textColor = .label
        textField.font = .preferredFont(forTextStyle: .caption1)

        return textField
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)

        return collectionView
    }()


    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        interactor?.fetchTags()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: isEditingMode ? "ellipsis.circle.fill" : "ellipsis.circle"), style: .plain, target: self, action: #selector(toggleState))
        navigationItem.rightBarButtonItem?.tintColor = .label

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.passing(selectedTag ?? tags.first!)
    }
    private func setupView(){
        view.backgroundColor = .systemBackground
        configureSheet()
        setupButtons()
        setupConstraints()
    }

    private func configureSheet(){
        // MARK: Modal Identifier Line
        modalIdentifierLine.center = view.center
        modalIdentifierLine.backgroundColor = .systemGray3
        modalIdentifierLine.layer.cornerRadius = .modalIdentifierLineCornerRadius

        // MARK: Label
        modalTagLabel.textColor = .label
        modalTagLabel.text = "Escolha uma Etiqueta"
        modalTagLabel.font = .preferredFont(for: .title2, weight: .bold)


        // MARK: Button & TextField
        tagNewTagButton.center = view.center
        tagNewTagButton.layer.borderWidth = 3
        tagNewTagButton.layer.borderColor = UIColor.black.cgColor
        tagNewTagButton.setTitleColor(.black, for: .normal)
        tagNewTagButton.setTitle("Nova Tag", for: .normal)
        tagNewTagButton.titleLabel?.font = .preferredFont(for: .title2, weight: .bold)
        tagNewTagButton.layer.cornerRadius = .tagCornerRadius

        textFieldTag.center = view.center
        textFieldTag.isHidden = true

    }

    private func setupButtons(){
        self.tagNewTagButton.addTarget(self, action: #selector(didTapNewTagButton), for: .touchUpInside)
    }

    private func setupConstraints() {
        let subviews = [
            // Modal Identifier line
            modalIdentifierLine,

            // Label
            modalTagLabel,

            // Buttons & TextField
            tagNewTagButton,
            textFieldTag,
            collectionView
        ]

        subviews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }


        NSLayoutConstraint.activate([
            // Modal Identifier Line
            modalIdentifierLine.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            modalIdentifierLine.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            modalIdentifierLine.heightAnchor.constraint(equalToConstant: view.bounds.height * .modalIdentifierLineHeightCtt),
            modalIdentifierLine.widthAnchor.constraint(equalToConstant: view.bounds.width * .modalIdentifierLineWidthCtt),

            // Label
            modalTagLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            modalTagLabel.topAnchor.constraint(equalTo: modalIdentifierLine.bottomAnchor, constant: 16),

            // MARK: Buttons & Text Field

            // New Tag
            tagNewTagButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tagNewTagButton.widthAnchor.constraint(equalToConstant: view.bounds.width - 60),
            tagNewTagButton.topAnchor.constraint(equalTo: modalTagLabel.bottomAnchor, constant: 12),
            tagNewTagButton.heightAnchor.constraint(equalToConstant: view.bounds.height * .tagHeightCtt),

            // Text Field
            textFieldTag.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            textFieldTag.widthAnchor.constraint(equalToConstant: view.bounds.width - 60),
            textFieldTag.topAnchor.constraint(equalTo: tagNewTagButton.bottomAnchor, constant: 12),
            textFieldTag.heightAnchor.constraint(equalToConstant: view.bounds.height * .tagHeightCtt),

            // Collection View

            collectionView.topAnchor.constraint(equalTo: textFieldTag.bottomAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

        ])
    }

    // MARK: Functions

    // Faz o botão de nova tag aparecer e desaparecer com o textField
    @objc private func didTapNewTagButton(){
        guard let unwrappedTextFieldText = textFieldTag.text else{ return }
        if !unwrappedTextFieldText.isEmpty{
            interactor?.addTag(unwrappedTextFieldText)
            textFieldTag.text = ""
            // Voltando ao estado original onde o textField está escondido
            isAddingNewTag.toggle()
            changeToAddingNewTagMode()
        } else {
            // Voltando ao estado original onde o textField está escondido
            isAddingNewTag.toggle()
            changeToAddingNewTagMode()
        }
    }

    func changeToAddingNewTagMode(){
        textFieldTag.isHidden = !isAddingNewTag
        if isAddingNewTag{
            tagNewTagButton.setTitle("Save", for: .normal)
        }else{
            tagNewTagButton.setTitle("New Tag", for: .normal)
        }
    }

    // Faz o botão de ... mudar de estado e chama a função changeToEditingMode
    @objc private func toggleState(){
        isEditingMode.toggle()
        changeToEditingMode()
    }

    // Muda para o modo de edição, onde as tags ppodem ser removidas
    func changeToEditingMode() {
        for i in arraybuttons{
            i.isHidden = !isEditingMode
        }
    }

    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

#Preview{
    SheetViewController()
}


// MARK: SheetViewController Extension

extension SheetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // Remove a tag do Array ao clicar no botão de -
    @objc private func removeButtonTapped(_ sender: UIButton){
        let index = sender.tag
        interactor?.deleteTag(tags[index])
    }

    // Ação para o botão dentro da collectionView
    @objc private func didTapButtonCV(_ sender: UIButton){
        selectedTag = tags[sender.tag]
        delegate?.passing(selectedTag!)
        print("\(tags[sender.tag]) tapped!")
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
            fatalError("Failed to dequeue cell")
        }

        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let myTagsView = UIButton(type: .system)
        myTagsView.setTitle(tags[indexPath.item], for: .normal)
        myTagsView.layer.borderWidth = 3
        myTagsView.layer.borderColor = UIColor.label.cgColor
        myTagsView.setTitleColor(.label, for: .normal)
        myTagsView.titleLabel?.font = .preferredFont(for: .title2, weight: .bold)
        myTagsView.layer.cornerRadius = .tagCornerRadius
        myTagsView.translatesAutoresizingMaskIntoConstraints = false
        myTagsView.tag = indexPath.item
        myTagsView.addTarget(self, action: #selector(didTapButtonCV), for: .touchUpInside)

        cell.contentView.addSubview(myTagsView)

        NSLayoutConstraint.activate([
            myTagsView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            myTagsView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            myTagsView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            myTagsView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])

        let removeButton = UIButton(type: .system)
        removeButton.setBackgroundImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        removeButton.tintColor = .systemGray
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.tag = indexPath.item
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        removeButton.isHidden = !isEditingMode

        if !arraybuttons.contains(removeButton) {
            arraybuttons.append(removeButton)
        }

        cell.contentView.addSubview(removeButton)

        NSLayoutConstraint.activate([
            removeButton.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            removeButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            removeButton.widthAnchor.constraint(equalToConstant: 24),
            removeButton.heightAnchor.constraint(equalToConstant: 24)
        ])

        return cell
    }
}

extension SheetViewController: UICollectionViewDelegateFlowLayout{



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width * .tagWidthCtt
        let height = tagNewTagButton.bounds.height

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }

}
