//
//  PomodoroView.swift
//  MAcro02-Grupo02
//
//  Created by Luca on 23/09/24.
//

import UIKit

class PomodoroViewController: UIViewController {
    var interactor: PomodoroInteractorProtocol!

    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.textAlignment = .center
        label.text = "25:00"
        return label
    }()
    
    private let startStopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        startStopButton.addTarget(self, action: #selector(didTapStartStop), for: .touchUpInside)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(timerLabel)
        view.addSubview(startStopButton)
        
        // Layout
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startStopButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 20)
        ])
    }
    
    @objc private func didTapStartStop() {
        interactor.startStopPomodoro()
    }
    
    func displayTime(_ time: String) {
        timerLabel.text = time
    }
    
    func updateButton(isRunning: Bool) {
        let buttonTitle = isRunning ? "Stop" : "Start"
        startStopButton.setTitle(buttonTitle, for: .normal)
    }
}
