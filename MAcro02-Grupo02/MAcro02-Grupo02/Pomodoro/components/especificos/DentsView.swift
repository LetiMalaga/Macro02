//
//  DentsView.swift
//  MAcro02-Grupo02
//
//  Created by Felipe Porto on 16/10/24.
//


import UIKit

class DentsView: UIView {

    private let shapeLayer = CAShapeLayer()
    private let shadowView = UIView()
    private let leftChevronImageView = UIImageView()
    private let rightChevronImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        createGearBar()
        setupShadowView()
        setupChevronImages()
        setupConstraints()
    }

    private func setupShadowView() {
        shadowView.backgroundColor = AppColors.primaryColor
        shadowView.layer.cornerRadius = 5
        addSubview(shadowView)
    }

    private func setupChevronImages() {
        // Configura a imagem do chevron esquerdo
        leftChevronImageView.image = UIImage(systemName: "chevron.left")
        leftChevronImageView.tintColor = AppColors.primaryColor
        leftChevronImageView.contentMode = .scaleAspectFit
        addSubview(leftChevronImageView)

        // Configura a imagem do chevron direito
        rightChevronImageView.image = UIImage(systemName: "chevron.right")
        rightChevronImageView.tintColor = AppColors.primaryColor
        rightChevronImageView.contentMode = .scaleAspectFit
        addSubview(rightChevronImageView)
    }

    private func createGearBar() {
        let path = UIBezierPath()

        let width: CGFloat = 300 // Largura da barra
        let height: CGFloat = 10 // Altura da barra
        let numberOfTeeth = 60 // Número de dentes
        let toothWidth = width / CGFloat(numberOfTeeth)

        for i in 0..<numberOfTeeth + 1 {
            let startX = CGFloat(i) * toothWidth
            let startY: CGFloat = 0
            var endY: CGFloat = 0

            if i % 5 == 0 {
                endY = -height
            } else {
                endY = -height / 2
            }

            path.move(to: CGPoint(x: startX, y: startY))
            path.addLine(to: CGPoint(x: startX, y: endY))
        }

        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 1
        shapeLayer.strokeColor = AppColors.primaryColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor

        layer.addSublayer(shapeLayer) // Adiciona a barra dentada como sublayer
    }

    private func setupConstraints() {
        // Habilita o uso de Auto Layout
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        leftChevronImageView.translatesAutoresizingMaskIntoConstraints = false
        rightChevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            shadowView.heightAnchor.constraint(equalToConstant: 5),
            
            leftChevronImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -25), // Alinhamento à esquerda
            leftChevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10), // Centralizado verticalmente
            leftChevronImageView.widthAnchor.constraint(equalToConstant: 20), // Largura do chevron
            leftChevronImageView.heightAnchor.constraint(equalTo: leftChevronImageView.widthAnchor), // Mantém a proporção
            
            rightChevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 25), // Alinhamento à direita
            rightChevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10), // Centralizado verticalmente
            rightChevronImageView.widthAnchor.constraint(equalToConstant: 20), // Largura do chevron
            rightChevronImageView.heightAnchor.constraint(equalTo: rightChevronImageView.widthAnchor), // Mantém a proporção
            
        ])
    }
}
