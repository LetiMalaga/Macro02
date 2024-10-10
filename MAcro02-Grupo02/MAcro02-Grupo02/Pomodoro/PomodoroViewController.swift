//
//  PomodoroViewController.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 23/09/24.
//

import UIKit

class PomodoroViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    var interactor: PomodoroInteractorProtocol?
    
    public var isRuning = false

    // UI Elements
    private let pauseLabel: UILabel = {
        let label = UILabel()
        label.text = "Mantenha pressionado para pausar"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "25:00"
        label.font = UIFont.systemFont(ofSize: 70, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let intervaloLabel: UILabel = {
        let label = UILabel()
        label.text = "Intervalo: 05:00"
        label.font = .boldSystemFont(ofSize: 22)
        label.layer.opacity = 0.3
        
        return label
    }()
    
    private let progressCircleView: TimerCircle = TimerCircle()
    
    private let playButton: PomoButton = {
        let pomo = PomoButton(frame: CGRect(x: 0, y: 0, width: 157, height: 60), titulo: "Iniciar")
        pomo.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        return pomo
    }()
    
    // Novo botão para retomar o Pomodoro
    private let resumeButton: PomoButton = {
        let pomo = PomoButton(frame: CGRect(x: 0, y: 0, width: 157, height: 60), titulo: "Continuar")
        pomo.addTarget(self, action: #selector(resume), for: .touchUpInside)
        pomo.isHidden = true // Inicialmente oculto
        return pomo
    }()
    
    private let tagframe: TagFrame = {
        let tagframe = TagFrame()
        return tagframe
    }()
    
    // Novo botão para resetar o Pomodoro
    private let resetButton: PomoButton = {
        let pomo = PomoButton(frame: CGRect(x: 0, y: 0, width: 157, height: 60), titulo: "Resetar")
        
        pomo.layer.borderColor = UIColor.black.cgColor
        pomo.layer.borderWidth = 2
        pomo.backgroundColor = .clear
        pomo.setTitleColor(.black, for: .normal)
        
        pomo.addTarget(self, action: #selector(reset), for: .touchUpInside)
        pomo.isHidden = true // Inicialmente oculto
        return pomo
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let pauseHold = UILongPressGestureRecognizer(target: self, action: #selector(pause))
        pauseHold.minimumPressDuration = 2.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tags))
        tagframe.addGestureRecognizer(tapGesture)
        
        view.addGestureRecognizer(pauseHold)
        
        setupLayout()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        // Add subviews
        view.addSubview(pauseLabel)
        view.addSubview(timeLabel)
        view.addSubview(progressCircleView)
        view.addSubview(playButton)
        view.addSubview(resumeButton)
        view.addSubview(resetButton)
        view.addSubview(intervaloLabel)
        view.addSubview(tagframe)
        
        // Disable autoresizing mask translation
        pauseLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        progressCircleView.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        resumeButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        intervaloLabel.translatesAutoresizingMaskIntoConstraints = false
        tagframe.translatesAutoresizingMaskIntoConstraints = false
        
        // Set constraints
        NSLayoutConstraint.activate([
            // Title Label
            pauseLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            pauseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Time Label
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            intervaloLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: -10),
            intervaloLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Progress Circle View
            progressCircleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressCircleView.centerYAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 40),
            progressCircleView.heightAnchor.constraint(equalToConstant: 150),
            
            tagframe.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tagframe.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 135),
            
            // Play/Pause Button
            playButton.topAnchor.constraint(equalTo: progressCircleView.bottomAnchor, constant: 90),
            playButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            // Resume Button
            resumeButton.topAnchor.constraint(equalTo: progressCircleView.bottomAnchor, constant: 90),
            resumeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            
            // Reset Button
            resetButton.topAnchor.constraint(equalTo: progressCircleView.bottomAnchor, constant: 90),
            resetButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapPlayPause() {
        playButton.isHidden = true
        isRuning = true
        intervaloLabel.isHidden = true
        pauseLabel.isHidden = false
        interactor?.startPomodoro(workDuration: 1, breakDuration: 1, loopCount: 4)
    }
    
    @objc func resume() {
        interactor?.resumePomodoro()
        resumeButton.isHidden = true
        isRuning = true
        resetButton.isHidden = true
    }
    
    @objc func reset() {
        
        updateCircle(percentage: 0)
        
        interactor?.stopPomodoro()
        resumeButton.isHidden = true
        resetButton.isHidden = true
        playButton.isHidden = false
        pauseLabel.isHidden = true
        intervaloLabel.isHidden = false
        isRuning = false
    }
    
    func complete() {
        resumeButton.isHidden = false
        resetButton.isHidden = false
        pauseLabel.isHidden = true
        isRuning = false
    }
    
    @objc func pause(gesture: UILongPressGestureRecognizer) {
        if isRuning {
            if gesture.state == .began {
                interactor?.pausePomodoro()
                
                resumeButton.isHidden = false
                resetButton.isHidden = false
            }
        }
    }
    
    func displayTime(_ time: String) {
           timeLabel.text = time
       }
       
       func updateCircle(percentage: Float) {
           progressCircleView.progress = percentage
       }
    
    @objc func tags() {
        let vc = TagModalsViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self

        if let popoverController = vc.popoverPresentationController {
            popoverController.delegate = self
            popoverController.permittedArrowDirections = .up
        }
        
        present(vc, animated: true, completion: nil)
    }

}

extension PomodoroViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

