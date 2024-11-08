//
//  PomodoroViewController.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 23/09/24.
//

import UIKit

class PomodoroViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var interactor: PomodoroInteractorProtocol?
    let pomoConfig = PomoDefaults()
    

    public var isRuning = false
    
    // UI Elements
    private let pauseLabel: UILabel = {
        let label = UILabel()
        label.text = "Mantenha pressionado para pausar"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .label
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 70, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private let intervaloLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.layer.opacity = 0.3
        label.textColor = .label
        
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
        
        pomo.layer.borderColor = UIColor.label.cgColor
        pomo.layer.borderWidth = 2
        pomo.backgroundColor = .clear
        pomo.setTitleColor(.label, for: .normal)
        
        pomo.addTarget(self, action: #selector(reset), for: .touchUpInside)
        pomo.isHidden = true // Inicialmente oculto
        return pomo
    }()
    
    func showBreathingExercise(_ time: String) {
        intervaloLabel.text = time // Breathing exercise text
        intervaloLabel.isHidden = false // Ensure it's visible during breathing phase
        timeLabel.isHidden = true // Hide main timer
    }
    
    func displayBreathingTime(_ time: String) {
            intervaloLabel.text = "Breathing: \(time)" // Display breathing countdown
        }
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        
        let workDuration = pomoConfig.workDuration
        let breakDuration = pomoConfig.breakDuration
        
        timeLabel.text = PomodoroInteractor().formatTime(workDuration * 60)
        intervaloLabel.text = "Intervalo: \(PomodoroInteractor().formatTime(breakDuration * 60))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Gestures
        
        let openConfigsGesture = UITapGestureRecognizer(target: self, action: #selector(configTime))
        timeLabel.addGestureRecognizer(openConfigsGesture)
        
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
            pauseLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
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
            tagframe.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
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
        interactor?.startPomodoro()
    }
    
    @objc func resume() {
        interactor?.resumePomodoro()
        resumeButton.isHidden = true
        isRuning = true
        resetButton.isHidden = true
        pauseLabel.isHidden = false
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
                pauseLabel.isHidden = true
            }
        }
    }
    
    func displayTime(_ time: String, isWorkPhase: Bool, isLongBreak: Bool = false) {
        timeLabel.text = time
        timeLabel.isHidden = false // Show main timer once breathing is done
        
        if isLongBreak {
            intervaloLabel.text = "Pausa Longa"
        } else if isWorkPhase {
            intervaloLabel.text = "Trabalho"
        } else {
            intervaloLabel.text = "Pausa"
        }
    }
    
    func updateCircle(percentage: Float) {
        progressCircleView.progress = percentage
    }
    
    @objc func tags() {
        
        let vc = ModalTagsFactory.makeModalTags(delegate: self)
        let navVC = UINavigationController(rootViewController: vc)
        
        if let sheet = navVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                context.maximumDetentValue * .modalViewHeightCtt
            }), .medium(), .large()]
        }
        
        navigationController?.present(navVC, animated: true)
    }
    
    @objc func configTime() {
        if !isRuning {
            let vc = SelectorViewController()
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension PomodoroViewController: UIViewControllerTransitioningDelegate, PassingTag {
    func passing(_ tag: String) {
        tagframe.tagline.text = tag
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}

