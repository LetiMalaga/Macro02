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
    
    var shortBreakActivities: [ActivitiesModel] = []
    
    var longBreakActivities: [ActivitiesModel] = []
    
    var activities: [ActivitiesModel] = [] {
        didSet { reloadData() }
    }
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let soundSwitch = UISwitch()
    private let vibrationSwitch = UISwitch()
    private let breathingSwitch = UISwitch()
    private let recommendationSwitch = UISwitch()
    var tags:[String] = []
    var editableSections: Set<Int> = []
    
    
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
        interactor?.fetchTags()
        
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
    
    func toggleEditMode(index:Int) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        tableView.reloadSections(IndexSet(integer: index), with: .automatic)
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
            return 0 // Respiração ao iniciar e Recomendação de atividades
        case 2:
            return 2 // Botão "Editar"
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
            cell.selectionStyle = .none
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
            let cell = UITableViewCell(style: .default, reuseIdentifier: "EditCell")
            cell.textLabel?.text = tableView.isEditing ? "Concluir" : "Editar"
            cell.textLabel?.textColor = .systemBlue
            cell.textLabel?.textAlignment = .right
            return cell
            
            
            
        case 2:
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
            
            //            let cell = UITableViewCell(style: .default, reuseIdentifier: "EditCell")
            //            cell.textLabel?.text = tableView.isEditing ? "Concluir" : "Editar"
            //            cell.textLabel?.textColor = .systemBlue
            //            cell.textLabel?.textAlignment = .center
            //            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)
            cell.selectionStyle = .none
            if indexPath.row == shortBreakActivities.count {
                cell.textLabel?.text = "+ Adicione uma atividade de descanso curto"
                cell.textLabel?.textColor = .systemBlue
            } else {
                cell.textLabel?.text = shortBreakActivities[indexPath.row].description
                cell.detailTextLabel?.text = shortBreakActivities[indexPath.row].tag
                cell.textLabel?.textColor = .black
                cell.detailTextLabel?.textColor = .black
            }
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)
            cell.selectionStyle = .none
            if indexPath.row < longBreakActivities.count {
                cell.textLabel?.text = longBreakActivities[indexPath.row].description
                cell.detailTextLabel?.text = longBreakActivities[indexPath.row].tag
                cell.textLabel?.textColor = .black
                cell.detailTextLabel?.textColor = .black
            } else {
                cell.textLabel?.text = "+ Adicione uma atividade de descanso longo"
                cell.textLabel?.textColor = .systemBlue
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemGroupedBackground
        let titleLabel = UILabel()
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        switch section {
        case 0:
            titleLabel.text = "App"
            titleLabel.textColor = .gray
        case 1:
            
            titleLabel.text = "Atividades personalizadas"
            titleLabel.font = .preferredFont(forTextStyle: .headline)
            
            
        case 2:
            titleLabel.text = "Sugestões"
            titleLabel.textColor = .gray
        case 3:
            titleLabel.text = "Intervalo Curto"
            titleLabel.font = .preferredFont(forTextStyle: .headline)
            
            makeButton()
        case 4:
            titleLabel.text = "Intervalo Longo"
            titleLabel.font = .preferredFont(forTextStyle: .headline)
            
            makeButton()
        default:
            titleLabel.text = ""
        }
        func font(_ title:String) -> UITableViewHeaderFooterView?{
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeader")
            header?.textLabel?.textColor = .black
            header?.textLabel?.text = title
            header?.textLabel?.font = .preferredFont(forTextStyle: .title3)
            
            return header
        }
        func makeButton(){
            let button = UIButton(type: .system)
            button.setTitle(tableView.isEditing ? "Concluir" : "Editar", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = section // Tag para identificar a seção
            button.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
            
            headerView.addSubview(titleLabel)
            headerView.addSubview(button)
            NSLayoutConstraint.activate([
                // Constraints para o título
                
                // Constraints para o botão
                button.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
                button.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
        }
        
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            // Constraints para o título
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        return headerView
    }
    
    // Função chamada ao pressionar o botão de editar
    @objc private func editButtonTapped(_ sender: UIButton) {
        let section = sender.tag
        toggleEditMode(index: section)
        if editableSections.contains(section) {
            // Remove a seção do modo de edição
            editableSections.remove(section)
        } else {
            // Adiciona a seção ao modo de edição
            editableSections.insert(section)
            
        }
        
        // Atualiza apenas as células na seção para mostrar o modo de edição
        let indexPaths = (0..<tableView.numberOfRows(inSection: section)).map { IndexPath(row: $0, section: section) }
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 && indexPath.row == shortBreakActivities.count {
            presentNewActivity(type: .short)
        } else if indexPath.section == 4 && indexPath.row == longBreakActivities.count {
            presentNewActivity(type: .long)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func presentNewActivity(type: ActivitiesType) {
        let newActivityVC = NewActivityViewController()
        newActivityVC.activityType = type
        newActivityVC.interactor = self.interactor
        newActivityVC.tags = self.tags
        
        if !tags.isEmpty{
            newActivityVC.modalPresentationStyle = .fullScreen
            present(newActivityVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if editableSections.contains(indexPath.section) {
            let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
            return indexPath.row < numberOfRows - 1 // Permite edição apenas se não for a última célula
        }
        return false
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
