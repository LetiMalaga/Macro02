//
//  TimeSelectorViewController.swift
//  MAcro02-Grupo02
//
//  Created by Felipe Porto on 16/10/24.
//

import UIKit

class TimeSelectorViewController: UIViewController {
    
    // vars
    
    let titlle:String
    let type:ConfigType
    var time: Int
    var predefinitions:[String] = []
    
    // pomodoro
    
    let pomoDefaults = PomoDefaults()
    
    // components
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .black
        
        return label
        
    }()
    
    let explanationLabel: UILabel = {
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 3
        label.textColor = .black
        
        return label
        
    }()
    
    let predefinedLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Tempos pré definidos"
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .black
        
        return label
        
    }()
    
    let selectorView: UIView = {
        
        let view = UIView()
        return view
        
    }()
    
    let timeLabel: UILabel = {
        
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 96)
        label.textColor = .black
        
        return label
        
    }()
    
    let scrollerView: UIView = {
        
        let view = UIView()
        return view
        
    }()
    
    let infiniteLabel: UILabel = {
        
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        label.text = "Com este modo ativado, o pomodoro é contado a partir do 0 e assim prossegue até que você o pare."
        label.textColor = .black.withAlphaComponent(0.6)

        
        return label
        
    }()
    
    let saveButton: PomoButton = {
        let button = PomoButton(frame: CGRect(x: 0, y: 0, width: 290, height: 60), titulo: "Salvar")
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        return button
    }()
    
    
    init(title: String, type: ConfigType, atualTime: Int) {
        
        self.type = type
        self.time = atualTime
        self.titlle = title
        
        super.init(nibName: nil, bundle: nil)
        
        titleLabel.text = title
        timeLabel.text = PomodoroInteractor().formatTime(atualTime)
        
        switch type {
        case .foco:
            explanationLabel.text = "Durante esse tempo, você se concentra exclusivamente em uma tarefa, evitando distrações."
            
            predefinitions = ["15M", "30M", "45M", "INF"]
            
        case .intervaloCurto:
            
            explanationLabel.text = "Uma pausa rápida entre os períodos de foco. Ele serve para dar à sua mente uma recuperação imediata e evitar o cansaço mental."
            
            predefinitions = ["5M", "10M", "15M", "20M"]
            
        case .intervaloLongo:
            
            explanationLabel.text = "Após completar os ciclos de foco, Esse intervalo ajuda a garantir que o cérebro tenha tempo suficiente para se recuperar, melhorando a produtividade no longo prazo."
            
            predefinitions = ["10M", "20M", "30M", "40M"]
            
        case .ciclosPomodoro:
            
            explanationLabel.text = "Durante esse tempo, você se concentra exclusivamente em uma tarefa, evitando distrações."
            
            predefinedLabel.text = "Ciclos pré definidos"
            
            predefinitions = ["2", "4", "6", "8"]
            
            timeLabel.text = "\(atualTime)"
        }
        
        
        
        
        print(title, type, atualTime)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        navigationItem.hidesBackButton = true
        
        setupLayout()
        
    }
    
    override func willChange(_ changeKind: NSKeyValueChange, valuesAt indexes: IndexSet, forKey key: String) {
    }
    
    func setupLayout() {
        
        view.addSubview(titleLabel)
        view.addSubview(explanationLabel)
        view.addSubview(predefinedLabel)
        view.addSubview(saveButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        predefinedLabel.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            explanationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            explanationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            explanationLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -20),
            explanationLabel.widthAnchor.constraint(equalToConstant: 358),
            
            predefinedLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            predefinedLabel.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor, constant: 40),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            
            
            
        ])
        
    }
    
    @objc func save() {
        
        switch type {
        case .foco:
            pomoDefaults.setTime(for: "workDuration", value: 1)
        case .intervaloCurto:
            pomoDefaults.setTime(for: "breakDuration", value: 1)
        case .intervaloLongo:
            pomoDefaults.setTime(for: "longBreakDuration", value: 2)
        case .ciclosPomodoro:
            pomoDefaults.setTime(for: "loopsQuantity", value: time)
        }
        
        navigationController?.popViewController(animated: true)
    }

}
