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
    
    var activities: [ActivitiesModel] = [] {
        didSet { tableView.reloadData() }
    }
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let soundSwitch = UISwitch()
    private let vibrationSwitch = UISwitch()
    private let breathingSwitch = UISwitch()
    private let recommendationSwitch = UISwitch()
    
    var interactor: SettingsIteractorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ajustes"
        view.backgroundColor = .white
        
        setupTableView()
        reloadData()
    }
    
    func reloadData() {
        interactor?.fetchActivities()
        
        longBreakActivities = activities.filter { $0.type == .long }
        shortBreakActivities = activities.filter { $0.type == .short }
        tableView.reloadData()
    }
    
    private func setupTableView() {
        let subviews = [tableView]
        
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SwitchCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ActivityCell")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CustomHeader")
    }
    
    @objc func toggleEditMode() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        tableView.reloadSections(IndexSet(integer: 4), with: .automatic)
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
        return 5 // APP, Sugestões, Atividades Personalizadas, Intervalo Curto, Intervalo Longo
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2 // Sons e Vibrações
        case 1:
            return 2 // Respiração ao iniciar e Recomendação de atividades
        case 2:
            return 1 // Botão "Editar"
        case 3:
            return shortBreakActivities.count + 1 // Atividades de intervalo curto + opção para adicionar
        case 4:
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
            let cell = UITableViewCell(style: .default, reuseIdentifier: "EditCell")
            cell.textLabel?.text = tableView.isEditing ? "Concluir" : "Editar"
            cell.textLabel?.textColor = .systemBlue
            cell.textLabel?.textAlignment = .center
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)
            if indexPath.row == shortBreakActivities.count {
                cell.textLabel?.text = "+ Adicione uma atividade de descanso curto"
                cell.textLabel?.textColor = .systemBlue
            } else {
                cell.textLabel?.text = shortBreakActivities[indexPath.row].description
                cell.textLabel?.textColor = .black
            }
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)
            if indexPath.row < longBreakActivities.count {
                cell.textLabel?.text = longBreakActivities[indexPath.row].description
                cell.textLabel?.textColor = .black
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
            return "Atividades personalizadas"
        case 3:
            return "Intervalo Curto"
        case 4:
            return "Intervalo Longo"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeader")
            header?.textLabel?.text = "Atividades personalizadas"
            header?.detailTextLabel?.text = "Aqui você pode adicionar suas próprias atividades personalizadas e desativar nossas recomendações"
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            toggleEditMode()
        } else if indexPath.section == 3 && indexPath.row == shortBreakActivities.count {
            presentNewActivity(type: .short)
        } else if indexPath.section == 4 && indexPath.row == longBreakActivities.count {
            presentNewActivity(type: .long)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func presentNewActivity(type: ActivitiesType) {
        let newActivityVC = NewActivityViewController()
        newActivityVC.activityType = type
        newActivityVC.modalPresentationStyle = .fullScreen
        present(newActivityVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 3 || indexPath.section == 4
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 3 {
//                interactor?.removeActivity(at: indexPath.row, type: .short)
            } else if indexPath.section == 4 {
//                interactor?.removeActivity(at: indexPath.row, type: .long)
            }
        }
    }
}

#Preview{
    SettingsViewController()
}
