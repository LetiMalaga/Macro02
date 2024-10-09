//
//  PomodoroViewController.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 23/09/24.
//

import UIKit
import UserNotifications
import CloudKit

class PomodoroViewController: UIViewController {
    var interactor: PomodoroInteractorProtocol!

    private let timerLabel = UILabel()
    private let stateLabel = UILabel()
    private let controlButton = UIButton(type: .system)
    private let stopButton = UIButton(type: .system)

    private let workDurationField = UITextField()
    private let breakDurationField = UITextField()
    private let loopCountField = UITextField()
    private let longRestDurationField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        requestNotificationPermission() // Request permission when view loads
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
        
        longRestDurationField.placeholder = "Long Rest Duration (min)"
        longRestDurationField.borderStyle = .roundedRect
        longRestDurationField.keyboardType = .numberPad
        longRestDurationField.textAlignment = .center

        [workDurationField, breakDurationField, loopCountField, longRestDurationField].forEach {
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
        let subviews = [timerLabel, stateLabel, workDurationField, breakDurationField, longRestDurationField, loopCountField, controlButton, stopButton]
        subviews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),

            stateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stateLabel.bottomAnchor.constraint(equalTo: timerLabel.topAnchor, constant: -20),

            workDurationField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            workDurationField.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 20),
            workDurationField.widthAnchor.constraint(equalToConstant: 200),

            breakDurationField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            breakDurationField.topAnchor.constraint(equalTo: workDurationField.bottomAnchor, constant: 10),
            breakDurationField.widthAnchor.constraint(equalToConstant: 200),
            
            longRestDurationField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            longRestDurationField.topAnchor.constraint(equalTo: loopCountField.bottomAnchor, constant: 10),
            longRestDurationField.widthAnchor.constraint(equalToConstant: 200),

            loopCountField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loopCountField.topAnchor.constraint(equalTo: breakDurationField.bottomAnchor, constant: 10),
            loopCountField.widthAnchor.constraint(equalToConstant: 200),

            controlButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controlButton.topAnchor.constraint(equalTo: loopCountField.bottomAnchor, constant: 50),
            controlButton.widthAnchor.constraint(equalToConstant: 200),
            controlButton.heightAnchor.constraint(equalToConstant: 50),

            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopButton.topAnchor.constraint(equalTo: controlButton.bottomAnchor, constant: 40),
            stopButton.widthAnchor.constraint(equalToConstant: 200),
            stopButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Failed to request notification permission: \(error)")
            }
        }
    }

    func displayTime(_ time: String) {
        timerLabel.text = time
    }

    func updateButton(isRunning: Bool, isPaused: Bool) {
        controlButton.setTitle(isRunning ? "Pause" : (isPaused ? "Resume" : "Start"), for: .normal)
        stopButton.isHidden = !isRunning
    }

    func updateStateLabel(_ text: String) {
        stateLabel.text = text
    }

    @objc private func controlButtonTapped() {
        if controlButton.title(for: .normal) == "Start" {
            let workDuration = Int(workDurationField.text ?? "") ?? 25
            let breakDuration = Int(breakDurationField.text ?? "") ?? 5
            let loopCount = Int(loopCountField.text ?? "") ?? 4
            let longRestDuration = Int(longRestDurationField.text ?? "") ?? 15 // Adding long rest logic
            interactor.startPomodoro(workDuration: workDuration, breakDuration: breakDuration, loopCount: loopCount, longRestDuration: longRestDuration)
        } else if controlButton.title(for: .normal) == "Pause" {
            interactor.pausePomodoro()
        } else if controlButton.title(for: .normal) == "Resume" {
            interactor.resumePomodoro()
        }
    }

    @objc private func stopButtonTapped() {
        interactor.stopPomodoro()
    }
}
