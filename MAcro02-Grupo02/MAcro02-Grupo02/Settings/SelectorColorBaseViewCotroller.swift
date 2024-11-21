//
//  SelectorColorBaseViewCotroller.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 21/11/24.
//

import Foundation
import UIKit

class SelectorColorBaseViewController: UIViewController {
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
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
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 60, height: 60) // Tamanho dos círculos
        layout.minimumLineSpacing = 20 // Espaçamento entre linhas
        layout.minimumInteritemSpacing = 20 // Espaçamento entre itens na mesma linha
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ColorCircleCell.self, forCellWithReuseIdentifier: ColorCircleCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let colorsBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private var selectedColorIndex: IndexPath?

    private let colors: [UIColor] = [
        UIColor(lightHex: 0xAA603C, darkHex: 0xAA603C),
        UIColor(lightHex: 0x2F9EBA, darkHex: 0x2F9EBA),
        UIColor(lightHex: 0x3688D1, darkHex: 0x3688D1),
        UIColor(lightHex: 0x3FAA20, darkHex: 0x3FAA20),
        UIColor(lightHex: 0x945CD9, darkHex: 0x945CD9),
        UIColor(lightHex: 0xC7508A, darkHex: 0xC7508A),
        UIColor(lightHex: 0xCB5048, darkHex: 0xCB5048),
        UIColor(lightHex: 0xD57622, darkHex: 0xD57622)
    ]
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        view.addSubview(saveButton)
        view.addSubview(colorsBackgroundView)
        colorsBackgroundView.addSubview(collectionView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        colorsBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            colorsBackgroundView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            colorsBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            colorsBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            colorsBackgroundView.heightAnchor.constraint(equalToConstant: 180),
            
            collectionView.topAnchor.constraint(equalTo: colorsBackgroundView.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: colorsBackgroundView.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: colorsBackgroundView.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: colorsBackgroundView.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SelectorColorBaseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCircleCell.identifier, for: indexPath) as? ColorCircleCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: colors[indexPath.row], isSelected: indexPath == selectedColorIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedColorIndex == indexPath {
            selectedColorIndex = nil // Desmarcar seleção
        } else {
            selectedColorIndex = indexPath // Atualizar índice selecionado
            //MARK: adicionar funcao que muda a cor do sistema
        }
        
        collectionView.reloadData()
    }
}

// MARK: - ColorCircleCell
class ColorCircleCell: UICollectionViewCell {
    static let identifier = "ColorCircleCell"
    
    private let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30 // Para formar um círculo
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            circleView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            circleView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            circleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with color: UIColor, isSelected: Bool) {
        circleView.backgroundColor = color
        circleView.layer.borderColor = isSelected ? UIColor.white.cgColor : UIColor.clear.cgColor
        circleView.layer.borderWidth = isSelected ? 4 : 0
    }
}
#Preview{
    SelectorColorBaseViewController()
}
