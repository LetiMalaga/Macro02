//
//  PomodoroViewController.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 23/09/24.
//

import UIKit
import UserNotifications
import CloudKit
import SwiftUI

class PomodoroViewController: UIViewController {
    var interactor: PomodoroInteractorProtocol!

    // UI Elements
    private let timerLabel = UILabel()
    private let stateLabel = UILabel()
    private let workDurationField = UITextField()
    private let breakDurationField = UITextField()
    private let loopCountField = UITextField()
    private let longRestDurationField = UITextField()
    private let progressCircleView: TimerCircle = TimerCircle()

    private let playButton = PomoButton(frame: CGRect(x: 0, y: 0, width: 157, height: 60), titulo: "Start")
    private let resumeButton = PomoButton(frame: CGRect(x: 0, y: 0, width: 157, height: 60), titulo: "Resume")
    private let resetButton = PomoButton(frame: CGRect(x: 0, y: 0, width: 157, height: 60), titulo: "Reset")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        requestNotificationPermission()

        playButton.addTarget(self, action: #selector(controlButtonTapped), for: .touchUpInside)
        resumeButton.addTarget(self, action: #selector(resume), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)

        let pauseHold = UILongPressGestureRecognizer(target: self, action: #selector(pause))
        pauseHold.minimumPressDuration = 2.0
        view.addGestureRecognizer(pauseHold)
    }

    private func setupView() {
        view.backgroundColor = .white
        setupLabelsAndFields()
        setupButtons()
        setupConstraints()
    }

    private func setupLabelsAndFields() {
        // Timer and state labels
        timerLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        timerLabel.textAlignment = .center
        timerLabel.text = "25:00"

        stateLabel.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        stateLabel.textAlignment = .center
        stateLabel.text = "Time to Work!"

        // Input fields for work, break, loops, long rest
        workDurationField.placeholder = "Work Duration (min)"
        breakDurationField.placeholder = "Break Duration (min)"
        loopCountField.placeholder = "Number of Loops"
        longRestDurationField.placeholder = "Long Rest Duration (min)"

        [workDurationField, breakDurationField, loopCountField, longRestDurationField].forEach {
            $0.borderStyle = .roundedRect
            $0.keyboardType = .numberPad
            $0.textAlignment = .center
        }
    }

    private func setupButtons() {
        playButton.setTitle("Start", for: .normal)
        playButton.backgroundColor = .systemBlue
        playButton.setTitleColor(.white, for: .normal)
        playButton.layer.cornerRadius = 10

        resumeButton.setTitle("Resume", for: .normal)
        resumeButton.backgroundColor = .systemGreen
        resumeButton.setTitleColor(.white, for: .normal)
        resumeButton.layer.cornerRadius = 10
        resumeButton.isHidden = true

        resetButton.setTitle("Reset", for: .normal)
        resetButton.backgroundColor = .systemRed
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.cornerRadius = 10
        resetButton.isHidden = true
    }

    private func setupConstraints() {
        // Add subviews and constraints
        view.addSubview(timerLabel)
        view.addSubview(stateLabel)
        view.addSubview(workDurationField)
        view.addSubview(breakDurationField)
        view.addSubview(loopCountField)
        view.addSubview(longRestDurationField)
        view.addSubview(playButton)
        view.addSubview(resumeButton)
        view.addSubview(resetButton)
        view.addSubview(progressCircleView)

        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        resumeButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        progressCircleView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
            stateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stateLabel.bottomAnchor.constraint(equalTo: timerLabel.topAnchor, constant: -20),
            progressCircleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressCircleView.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 20),
            playButton.topAnchor.constraint(equalTo: progressCircleView.bottomAnchor, constant: 50),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resumeButton.topAnchor.constraint(equalTo: progressCircleView.bottomAnchor, constant: 50),
            resumeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resetButton.topAnchor.constraint(equalTo: progressCircleView.bottomAnchor, constant: 50),
            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc private func controlButtonTapped() {
        // Start button logic (connect to backend)
        let workDuration = Int(workDurationField.text ?? "") ?? 25
        let breakDuration = Int(breakDurationField.text ?? "") ?? 5
        let loopCount = Int(loopCountField.text ?? "") ?? 4
        let longRestDuration = Int(longRestDurationField.text ?? "") ?? 15
        let wantsBreathing = true // Add this toggle to UI later

        interactor.startPomodoro(workDuration: workDuration, breakDuration: breakDuration, loopCount: loopCount, longRestDuration: longRestDuration, wantsBreathing: wantsBreathing)
    }

    @objc func resume() {
        interactor.resumePomodoro()
        resumeButton.isHidden = true
        resetButton.isHidden = true
    }

    @objc func reset() {
        interactor.stopPomodoro()
        resetButton.isHidden = true
        playButton.isHidden = false
    }

    @objc func pause(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            interactor.pausePomodoro()
            resumeButton.isHidden = false
            resetButton.isHidden = false
        }
    }

    // Add these methods to interact with the presenter
    func updateButton(isRunning: Bool, isPaused: Bool) {
        // Update the button title based on the running state
        playButton.setTitle(isRunning ? "Pause" : (isPaused ? "Resume" : "Start"), for: .normal)
        playButton.isHidden = isRunning
    }

    func updateStateLabel(_ text: String) {
        stateLabel.text = text
    }

    // Progress update logic
    func updateCircle(percentage: Float) {
        progressCircleView.progress = percentage
    }

    // Update the time display
    func displayTime(_ time: String) {
        timerLabel.text = time
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Failed to request notification permission: \(error)")
            }
        }
    }
    
}

#Preview {
    PomodoroViewController().showLivePreview()
}
