//
//  PomodoroViewController.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 23/09/24.
//

import UIKit

protocol BreathingCompletionDelegate: AnyObject {
    func didFinishBreathingExercise()
}

class PomodoroViewController: UIViewController, UIPopoverPresentationControllerDelegate, BreathingCompletionDelegate {
    
    var interactor: PomodoroInteractorProtocol?
    let pomoConfig = PomoDefaults()
    private var progressTimer: Timer?
    

    public var isRuning = false
    
    // UI Elements
    private var progressView: ProgressUiView = {
        let progress = ProgressUiView()
        progress.isHidden = true
        progress.label.text = NSLocalizedString("Mantenha pressionado para pausar", comment: "PomodoroViewController")
        
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private let activityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true // Initially hidden until we load an activity
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 70, weight: .bold)
        label.textColor = UIColor.customText
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private let intervaloLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.layer.opacity = 0.3
        label.textColor = UIColor.customText
        
        return label
    }()
    
    private let progressCircleView: TimerCircle = TimerCircle()
    
    private let playButton: PomoButton = {
        let pomo = PomoButton(frame: CGRect(x: 0, y: 0, width: 157, height: 60), titulo: NSLocalizedString("Iniciar", comment: "Botão de iniciar pomodoro"))
        pomo.backgroundColor = .customAccentColor
        pomo.setTitleColor(.customTextOpposite, for: .normal)
        pomo.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        return pomo
    }()
    
    // Novo botão para retomar o Pomodoro
    private let resumeButton: PomoButton = {
        let pomo = PomoButton(frame: CGRect(x: 0, y: 0, width: 157, height: 60), titulo: NSLocalizedString("Continuar", comment: "Botão de continuar pomodoro"))
        pomo.backgroundColor = .customAccentColor
        pomo.setTitleColor(.customTextOpposite, for: .normal)
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
        let pomo = PomoButton(frame: CGRect(x: 0, y: 0, width: 157, height: 60), titulo: NSLocalizedString("Resetar", comment: "Botão de resetar pomodoro"))
        pomo.setTitleColor(.customText, for: .normal)
        
        pomo.layer.borderWidth = 2
        pomo.backgroundColor = .clear
        
        pomo.addTarget(self, action: #selector(reset), for: .touchUpInside)
        pomo.isHidden = true // Inicialmente oculto
        return pomo
    }()
    
    @objc private func didTapPlayPause() {
        
        // Present the BreathingViewController for the breathing exercise if needed
        let breathingVC = BreathingViewController()
        breathingVC.delegate = self
        breathingVC.modalPresentationStyle = .fullScreen
        present(breathingVC, animated: true, completion: nil)
    }

        // Método do protocolo que será chamado quando o exercício de respiração terminar
        func didFinishBreathingExercise() {
            // Inicia o cronômetro após o exercício de respiração
            playButton.isHidden = true
            isRuning = true
            intervaloLabel.isHidden = true
            progressView.isHidden = false
            interactor?.startPomodoro()
            
            // sumindo com a tag
            
            tagframe.isHidden = true
        }
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        
        let workDuration = pomoConfig.workDuration
        let breakDuration = pomoConfig.breakDuration
        
        
        timeLabel.text = PomodoroInteractor().formatTime(workDuration * 60)
        intervaloLabel.text = "\(NSLocalizedString("Intervalo", comment: "PomodoroViewController")): \(PomodoroInteractor().formatTime(breakDuration * 60))"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBGColor
        
        progressView.function = { _ in self.pause() }
        
        // Gestures
        
        let openConfigsGesture = UITapGestureRecognizer(target: self, action: #selector(configTime))
        timeLabel.addGestureRecognizer(openConfigsGesture)
        
        let pauseHold = UILongPressGestureRecognizer(target: self, action: #selector(handleHold))
        pauseHold.minimumPressDuration = 1.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tags))
        tagframe.addGestureRecognizer(tapGesture)
        
        view.addGestureRecognizer(pauseHold)
        
        setupLayout()
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        // Add subviews
        view.addSubview(progressView)
        view.addSubview(timeLabel)
        view.addSubview(progressCircleView)
        view.addSubview(playButton)
        view.addSubview(resumeButton)
        view.addSubview(resetButton)
        view.addSubview(intervaloLabel)
        view.addSubview(tagframe)
        view.addSubview(activityLabel)
        activityLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Position it just below the "Iniciar" button
            activityLabel.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20),
            activityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            activityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        // Disable autoresizing mask translation
        progressView.translatesAutoresizingMaskIntoConstraints = false
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
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
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
            tagframe.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
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
    
    @objc func resume() {
        interactor?.resumePomodoro()
        resumeButton.isHidden = true
        isRuning = true
        
        // sumindo com a tag
        
        tagframe.isHidden = true
        
        resetButton.isHidden = true
        progressView.isHidden = false
    }
    
    @objc func reset() {
        
        updateCircle(percentage: 0)
        
        resumeButton.isHidden = true
        resetButton.isHidden = true
        playButton.isHidden = false
        progressView.isHidden = true
        intervaloLabel.isHidden = false
        interactor?.stopPomodoro()
        
        // Voltando a tag
        
        tagframe.isHidden = false
        
        isRuning = false
    }
    
    func complete() {
        resumeButton.isHidden = false
        resetButton.isHidden = false
        progressView.isHidden = true
        isRuning = false
    }
    
    @objc func pause() {
        if isRuning {

                interactor?.pausePomodoro()
            
                // Voltando a tag
                
                tagframe.isHidden = false
                
                resumeButton.isHidden = false
                resetButton.isHidden = false
                progressView.isHidden = true
            
        }
    }
    
    func displayActivity(_ description: String) {
        activityLabel.text = description
        activityLabel.isHidden = false // Show the label with the fetched activity
    }
    
    func displayTime(_ time: String, isWorkPhase: Bool, isLongBreak: Bool = false) {
        timeLabel.text = time
        timeLabel.isHidden = false // Show main timer once breathing is done
        
        if isLongBreak {
            intervaloLabel.text = NSLocalizedString("Pausa Longa", comment: "PomodoroViewController")
        } else if isWorkPhase {
            intervaloLabel.text = NSLocalizedString("Trabalho", comment: "PomodoroViewController")
        } else {
            intervaloLabel.text = NSLocalizedString("Pausa", comment: "PomodoroViewController")
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
            }), .medium()/*, .large()*/]
        }
        
        navigationController?.present(navVC, animated: true)
    }
    
    @objc func configTime() {
        if !isRuning {
            let vc = SelectorViewController()
            
            navigationController?.pushViewController(vc, animated: true)
        }
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
    
}

//#Preview {
//    PomodoroViewController()
//}

extension PomodoroViewController: UIViewControllerTransitioningDelegate, PassingTag {
    func passing(_ tag: String) {
        tagframe.tagline.text = tag
        self.interactor?.tagTime = tag
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}

