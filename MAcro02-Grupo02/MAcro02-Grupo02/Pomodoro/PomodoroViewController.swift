//
//  PomodoroView.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 23/09/24.
//

import UIKit

class PomodoroViewController: UIViewController {
    var interactor: PomodoroInteractorProtocol!
    
    private let timerLabel = UILabel()
    private let stateLabel = UILabel()
    private let controlButton = UIButton(type: .system)
    private let stopButton = UIButton(type: .system)
    
    private let workDurationField = UITextField()
    private let breakDurationField = UITextField()
    private let loopCountField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        controlButton.addTarget(self, action: #selector(controlButtonTapped), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        setupLabelsAndFields()
        setupButtons()
        setupConstraints()
    }
    
    private func setupLabelsAndFields() {
        timerLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        timerLabel.textAlignment = .center
        timerLabel.text = "25:00"
        
        stateLabel.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        stateLabel.textAlignment = .center
        stateLabel.text = "Time to Work!"
        
        workDurationField.placeholder = "Work Duration (min)"
        breakDurationField.placeholder = "Break Duration (min)"
        loopCountField.placeholder = "Number of Loops"
        
        [workDurationField, breakDurationField, loopCountField].forEach {
            $0.borderStyle = .roundedRect
            $0.keyboardType = .numberPad
            $0.textAlignment = .center
        }
    }
    
    private func setupButtons() {
        controlButton.setTitle("Start", for: .normal)
        controlButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        controlButton.backgroundColor = .systemBlue
        controlButton.setTitleColor(.white, for: .normal)
        controlButton.layer.cornerRadius = 10

        stopButton.setTitle("Stop", for: .normal)
        stopButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        stopButton.backgroundColor = .systemRed
        stopButton.setTitleColor(.white, for: .normal)
        stopButton.layer.cornerRadius = 10
        stopButton.isHidden = true
    }
    
    private func setupConstraints() {
        let subviews = [timerLabel, stateLabel, workDurationField, breakDurationField, loopCountField, controlButton, stopButton]
        subviews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Timer and labels
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
            
            stateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stateLabel.bottomAnchor.constraint(equalTo: timerLabel.topAnchor, constant: -20),
            
            // Text fields
            workDurationField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            workDurationField.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 20),
            workDurationField.widthAnchor.constraint(equalToConstant: 200),
            
            breakDurationField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            breakDurationField.topAnchor.constraint(equalTo: workDurationField.bottomAnchor, constant: 10),
            breakDurationField.widthAnchor.constraint(equalToConstant: 200),
            
            loopCountField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loopCountField.topAnchor.constraint(equalTo: breakDurationField.bottomAnchor, constant: 10),
            loopCountField.widthAnchor.constraint(equalToConstant: 200),
            
            // Control button
            controlButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controlButton.topAnchor.constraint(equalTo: loopCountField.bottomAnchor, constant: 20),
            controlButton.widthAnchor.constraint(equalToConstant: 150),
            controlButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Stop button
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopButton.topAnchor.constraint(equalTo: controlButton.bottomAnchor, constant: 10),
            stopButton.widthAnchor.constraint(equalToConstant: 150),
            stopButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func controlButtonTapped() {
        if controlButton.titleLabel?.text == "Start" {
            let workDuration = Int(workDurationField.text ?? "25") ?? 25
            let breakDuration = Int(breakDurationField.text ?? "5") ?? 5
            let loopCount = Int(loopCountField.text ?? "4") ?? 4
            interactor.startPomodoro(workDuration: workDuration, breakDuration: breakDuration, loopCount: loopCount)
        } else if controlButton.titleLabel?.text == "Pause" {
            interactor.pausePomodoro()
        } else if controlButton.titleLabel?.text == "Resume" {
            interactor.resumePomodoro()
        }
    }
    
    @objc private func stopButtonTapped() {
        interactor.stopPomodoro()
    }
    
    func displayTime(_ time: String) {
        timerLabel.text = time
    }
    
    func updateButton(isRunning: Bool, isPaused: Bool) {
        if isRunning {
            controlButton.setTitle("Pause", for: .normal)
            stopButton.isHidden = true
        } else if isPaused {
            controlButton.setTitle("Resume", for: .normal)
            stopButton.isHidden = false
        } else {
            controlButton.setTitle("Start", for: .normal)
            stopButton.isHidden = true
        }
    }
    
    func updateStateLabel(_ text: String) {
            stateLabel.text = text  // Update the state label's text
        }
}
