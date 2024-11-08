//
//  BreathingViewController.swift
//  MAcro02-Grupo02
//
//  Created by Felipe Porto on 31/10/24.
//

import UIKit

class BreathingViewController: UIViewController {
    
    let estados = ["Inspire", "Segure", "Expire"]
    var estadoAtual: Int = 0
    var breathing = false
    var cycleCount = 0
    private var progressTimer: Timer?
    
    weak var delegate: BreathingCompletionDelegate?
    
    private var progressView: ProgressUiView = {
        let progress = ProgressUiView()
        
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private let outerCircle: CAShapeLayer = {
        let bezier = UIBezierPath(arcCenter: .zero, radius: 150, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezier.cgPath
        shapeLayer.fillColor = AppColors.progressPrimary.cgColor
        return shapeLayer
    }()
    
    private let innerCircle: CAShapeLayer = {
        let bezier = UIBezierPath(arcCenter: .zero, radius: 50, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezier.cgPath
        shapeLayer.fillColor = AppColors.progressSecundary.withAlphaComponent(0.5).cgColor
        shapeLayer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
        return shapeLayer
    }()
    
    private var stateLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColors.textPrimary
        label.font = AppFonts.largeTitle.bold()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "aperte para começar"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.backgroundColor = AppColors.backgroundPrimary
        
        progressView.function = { _ in self.endBreathingCycle() }
        
        let startTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(startTap)
        
        let jumpHold = UILongPressGestureRecognizer(target: self, action: #selector(handleHold))
        jumpHold.minimumPressDuration = 1.0
        view.addGestureRecognizer(jumpHold)
        
        view.addSubview(progressView)
        view.addSubview(stateLabel)
        view.layer.addSublayer(outerCircle)
        view.layer.addSublayer(innerCircle)
        
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            stateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
        ])
        
        innerCircle.position = view.center
        outerCircle.position = view.center
    }
    
    @objc func handleHold(gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began {
                startProgress()
            } else if gesture.state == .ended {
                stopProgress()
            }
        }
    
    private func startProgress() {
           progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
       }
       
       private func stopProgress() {
           progressTimer?.invalidate()
           progressView.resetProgress()
       }
       
       @objc private func updateProgress() {
           progressView.updateProgress()
       }
       
    
    @objc private func handleTap(gesture: UITapGestureRecognizer) {
        if !breathing {
            breathing = true
            estadoAtual = 0
            cycleCount = 0  // Reinicia o contador de ciclos ao iniciar
            startBreathingCycle()
        }
    }
    
    private func startBreathingCycle() {
            if cycleCount < 1 {  // Verifica se o número de ciclos é menor que 3
                updateStateLabel()
                animateInnerCircleExpansion()
            } else {
                endBreathingCycle()
            }
        }
    
    private func updateStateLabel() {
        stateLabel.text = estados[estadoAtual]
    }
    
    private func endBreathingCycle() {
        
        // Notifica o delegate de que a respiração terminou
        delegate?.didFinishBreathingExercise()
        
        // Fecha a tela de respiração
        dismiss(animated: true, completion: nil)
        
    }
    
    private func animateInnerCircleExpansion() {
        let expandAnimation = CABasicAnimation(keyPath: "transform.scale")
        expandAnimation.fromValue = 1.0
        expandAnimation.toValue = 2.0
        expandAnimation.duration = 4.0
        expandAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        expandAnimation.fillMode = .forwards
        expandAnimation.isRemovedOnCompletion = false
        
        innerCircle.add(expandAnimation, forKey: "expand")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            self.estadoAtual = 1
            self.updateStateLabel()
            self.animateInnerCircleHold()
        }
    }
    
    private func animateInnerCircleHold() {
        let holdAnimation = CABasicAnimation(keyPath: "transform.scale")
        holdAnimation.fromValue = 2.0
        holdAnimation.toValue = 2.0
        holdAnimation.duration = 7.0
        holdAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        holdAnimation.fillMode = .forwards
        holdAnimation.isRemovedOnCompletion = false
        
        innerCircle.add(holdAnimation, forKey: "hold")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.5) {
            self.estadoAtual = 2
            self.updateStateLabel()
            self.animateInnerCircleContraction()
        }
    }
    
    private func animateInnerCircleContraction() {
        let contractAnimation = CABasicAnimation(keyPath: "transform.scale")
        contractAnimation.fromValue = 2.0
        contractAnimation.toValue = 1.0
        contractAnimation.duration = 8.0
        contractAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        contractAnimation.fillMode = .forwards
        contractAnimation.isRemovedOnCompletion = false
        
        innerCircle.add(contractAnimation, forKey: "contract")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.5) {
            if self.breathing {
                self.cycleCount += 1  // Incrementa o contador de ciclos
                self.estadoAtual = 0
                self.startBreathingCycle()
            }
        }
    }
}
