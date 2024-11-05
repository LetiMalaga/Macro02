//
//  SettingsViewController.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 01/11/24.
//
import Foundation
import UIKit

class SettingsViewController: UIViewController, SettingsViewProtocol {
    
    var soundButton: Bool = false {
        didSet { soundSwitch.isOn = soundButton }
    }
    
    var vibrationButton: Bool = false {
        didSet { vibrationSwitch.isOn = vibrationButton }
    }
    
    var breathingButton: Bool = false {
        didSet { breathingSwitch.isOn = breathingButton }
    }
    
    var recommendationButton: Bool = false {
        didSet { recommendationSwitch.isOn = recommendationButton }
    }
    
    var shortBreakActivities: [ActivitiesModel] = [] {
        didSet { tableView.reloadData() }
    }
    
    var longBreakActivities: [ActivitiesModel] = [] {
        didSet { tableView.reloadData() }
    }
    var activitys: [ActivitiesModel] = [] {
        didSet { tableView.reloadData() }
    }
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let soundSwitch = UISwitch()
    private let vibrationSwitch = UISwitch()
    private let breathingSwitch = UISwitch()
    private let recommendationSwitch = UISwitch()
    private var editableTable:Int?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "Ajustes" // Defina o título desejado
        return label
    }()
    
    var interactor: SettingsIteractorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ajustes"
        view.backgroundColor = .white
        
        navigationItem.title = "Ajustes"
        
        setupTableView()
        reloadData()
    }
    func reloadData() {
        interactor?.fetchActivities()
        
        longBreakActivities = activitys.filter{$0.type == .long}
        shortBreakActivities = activitys.filter{$0.type == .short}
        tableView.reloadData()
    }
    private func setupTableView() {
        let subviews = [
            tableView
        ]
        
        subviews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Register cells
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SwitchCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ActivityCell")
    }
    
    @objc func soundSwitchChanged(_ sender: UISwitch) {
        interactor?.changeSound()
    }
    
    @objc func vibrationSwitchChanged(_ sender: UISwitch) {
        interactor?.changeVibration()
    }
    
    @objc func breathingSwitchChanged(_ sender: UISwitch) {
        interactor?.changeBreathing()
    }
    
    @objc func recommendationSwitchChanged(_ sender: UISwitch) {
        interactor?.changeRecomendations()
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4 // APP, Sugestões, Intervalo Curto, Intervalo Longo
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2 // Sons e Vibrações
        case 1:
            return 2 // Respiração ao iniciar e Recomendação de atividades
        case 2:
            return shortBreakActivities.count + 1 // Atividades de intervalo curto + opção para adicionar
        case 3:
            return longBreakActivities.count + 1 // Atividades de intervalo longo + opção para adicionar
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath)
            if indexPath.row == 0 {
                cell.textLabel?.text = "Sons"
                soundSwitch.isOn = soundButton
                soundSwitch.addTarget(self, action: #selector(soundSwitchChanged(_:)), for: .valueChanged)
                cell.accessoryView = soundSwitch
            } else {
                cell.textLabel?.text = "Vibrações"
                vibrationSwitch.isOn = vibrationButton
                vibrationSwitch.addTarget(self, action: #selector(vibrationSwitchChanged(_:)), for: .valueChanged)
                cell.accessoryView = vibrationSwitch
            }
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath)
            if indexPath.row == 0 {
                cell.textLabel?.text = "Respiração ao iniciar pomodoro"
                breathingSwitch.isOn = breathingButton
                breathingSwitch.addTarget(self, action: #selector(breathingSwitchChanged(_:)), for: .valueChanged)
                cell.accessoryView = breathingSwitch
            } else {
                cell.textLabel?.text = "Recomendação de atividades"
                recommendationSwitch.isOn = recommendationButton
                recommendationSwitch.addTarget(self, action: #selector(recommendationSwitchChanged(_:)), for: .valueChanged)
                cell.accessoryView = recommendationSwitch
            }
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)
            
            if indexPath.row == shortBreakActivities.count {
                cell.textLabel?.text = "+ Adicione uma atividade de descanso curto"
                cell.textLabel?.textColor = .systemBlue
            } else {
                cell.textLabel?.text = shortBreakActivities[indexPath.row].Description
                cell.textLabel?.textColor = .black
            }
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)
            if indexPath.row < longBreakActivities.count {
                cell.textLabel?.text = longBreakActivities[indexPath.row].Description
//                cell.detailTextLabel?.text = longBreakActivities[indexPath.row].description
            } else {
                cell.textLabel?.text = "+ Adicione uma atividade de descanso longo"
                cell.textLabel?.textColor = .systemBlue
            }
            return cell
            
        default:
            
            return UITableViewCell()
        }

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "App"
        case 1:
            return "Sugestões"
        case 2:
            return "Intervalo Curto"
        case 3:
            return "Intervalo Longo"
        default:
            return nil
        }
    }

    @objc func editButtonTapped(_ sender: UIButton) {
        let section = sender.tag
        
        if let eT = editableTable {
            if eT == section {
                editableTable = nil
                self.tableView.setEditing(false, animated: true)
            } else {
                editableTable = section
                self.tableView.setEditing(true, animated: true)
            }
        } else {
            editableTable = section
            self.tableView.setEditing(true, animated: true)
        }
        
        self.tableView.reloadData()
    }
}

#Preview {
    SettingsViewController()
}
