//
//  GearBarView.swift
//  MAcro02-Grupo02
//
//  Created by Felipe Porto on 16/10/24.
//


import UIKit
import CoreHaptics

class GearBarView: UIView {
    
    let pomoDefaults = PomoDefaults()
    let cicle:Bool

    var timeInMinutes: Int = 0 {
        didSet {
            if cicle {
                timeLabel.text = String(timeInMinutes)
            } else {
                timeLabel.text = String(format: "%02d:00", timeInMinutes)
            }
            
            // Vibra quando o tempo é setado
            if UserDefaults.standard.bool(forKey: "sound"){
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            }
        }
    }
    
    // Label para exibir o tempo
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 96, weight: .bold)
        label.textColor = .customText
        label.textAlignment = .center
        return label
    }()

    init(frame: CGRect, initialTime: Int, cicle: Bool) {
        self.cicle = cicle
        self.timeInMinutes = initialTime

        if cicle {
            timeLabel.text = String(timeInMinutes)
        } else {
            timeLabel.text = String(format: "%02d:00", timeInMinutes)
        }
        
        super.init(frame: frame)
        
        setupView()
    }

    required init?(coder: NSCoder) {
        self.timeInMinutes = 25
        self.cicle = false
        
        super.init(coder: coder)
        
        isUserInteractionEnabled = true
        
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        // Adicionar o label de tempo
        addSubview(timeLabel)
        
        // Layout
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100),
            timeLabel.widthAnchor.constraint(equalToConstant: 300),
        ])
    }
    
    func updateTime(time: Int) {
        if !cicle {
            timeInMinutes = min(max(5, time), 60)
        } else {
            timeInMinutes = min(max(1, time), 60)
        }
        
    }
    
    // Método para manipular o gesto de arraste
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        var vibrate: Bool = false
        
        let translation = gesture.translation(in: self)
        var increment = Int(translation.x / 4)
        
        if gesture.state == .began {
            vibrate = false
        }
        
        if gesture.state == .changed || gesture.state == .ended {
            // Incremento baseado no gesto de arraste
            
            if cicle {
                increment = Int(translation.x / 10)
            } else {
                increment = Int(translation.x / 10) * 5
            }
            
            // Ajuste o divisor para ajustar a sensibilidade do arraste
            let newTime = timeInMinutes + increment
            
            if !vibrate && UserDefaults.standard.bool(forKey: "sound") {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                vibrate = true
            }
            
            // Atualiza o valor de time no GearBarView
            updateTime(time: newTime)
            
        }
        
        // Resetar a tradução para zero
        gesture.setTranslation(.zero, in: self)
        

    }
}
