//
//  GearBarView.swift
//  MAcro02-Grupo02
//
//  Created by Felipe Porto on 16/10/24.
//


import UIKit

class GearBarView: UIView {
    
    let pomoDefaults = PomoDefaults()

    var timeInMinutes: Int {
        didSet {
            timeLabel.text = String(format: "%02d:00", timeInMinutes)
        }
    }
    
    // Label para exibir o tempo
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 96, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // Barra dentada como um componente separado
    private let dentsView = DentsView()

    init(frame: CGRect, initialTime: Int) {
        self.timeInMinutes = initialTime
        
        timeLabel.text = String(format: "%02d:00", initialTime)
        
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        self.timeInMinutes = 25
        super.init(coder: coder)
        
        isUserInteractionEnabled = true
        
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        // Adicionar o label de tempo
        addSubview(timeLabel)
        addSubview(dentsView)
        
        // Adicionar gesto de arraste
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.addGestureRecognizer(panGesture)
        
        // Layout
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        dentsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -60),
            timeLabel.widthAnchor.constraint(equalToConstant: 300),
            
            dentsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            dentsView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 30),
            dentsView.widthAnchor.constraint(equalToConstant: 300),
            dentsView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func updateTime(time: Int) {
        timeInMinutes = max(5, time)  // Garantir que o tempo não seja negativo
        
    }
    
    // Método para manipular o gesto de arraste
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        if gesture.state == .changed || gesture.state == .ended {
            // Incremento baseado no gesto de arraste
            let increment = Int(translation.x / 5)  // Ajuste o divisor para ajustar a sensibilidade do arraste
            let newTime = timeInMinutes + increment
            
            // Atualiza o valor de time no GearBarView
            updateTime(time: newTime)
        }
        
        // Resetar a tradução para zero
        gesture.setTranslation(.zero, in: self)
    }
}
