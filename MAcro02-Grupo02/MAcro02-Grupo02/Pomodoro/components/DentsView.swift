//
//  DentsView.swift
//  MAcro02-Grupo02
//
//  Created by Felipe Porto on 16/10/24.
//


import UIKit

class DentsView: UIView {
    
    private let shapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        createGearBar()
    }
    
    // Método para criar a barra dentada
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
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(shapeLayer)
    }
}
