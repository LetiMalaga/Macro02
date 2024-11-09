////
////  Teste.swift
////  MAcro02-Grupo02
////
////  Created by Luiz Felipe on 08/11/24.
////
//
//import Foundation
//import UIKit
//
//class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    private let tableView = UITableView(frame: .zero, style: .grouped)
//    
//    private var shortBreakActivities = ["Exercício de respiração por 2 minutos"]
//    private var longBreakActivities = ["Caminhe em um ambiente aberto"]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//    }
//    
//    private func setupView() {
//        view.backgroundColor = .systemBackground
//        title = "Ajustes"
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(tableView)
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    // MARK: - Table View Data Source
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 4 // Notifications, Custom Activities, Suggestions, Appearance
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0: return 2 // Sounds, Vibrations
//        case 1: return 1 // Custom Activities
//        case 2: return 2 + shortBreakActivities.count + longBreakActivities.count + 2 // Suggestions with dynamic rows
//        case 3: return 3 // Appearance options
//        default: return 0
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.selectionStyle = .none
//        
//        switch indexPath.section {
//        case 0:
//            if indexPath.row == 0 {
//                cell.textLabel?.text = "Sons"
//                let switchView = UISwitch()
//                switchView.isOn = true
//                cell.accessoryView = switchView
//            } else {
//                cell.textLabel?.text = "Vibrações"
//                let switchView = UISwitch()
//                switchView.isOn = true
//                cell.accessoryView = switchView
//            }
//            
//        case 1:
////            cell.textLabel?.text = "Atividades Personalizadas"
//            cell.detailTextLabel?.text = "Aqui você pode adicionar suas próprias atividades..."
//            cell.detailTextLabel?.numberOfLines = 0
//            
//        case 2:
//            if indexPath.row == 0 {
//                cell.textLabel?.text = "Respiração ao iniciar pomodoro"
//                let switchView = UISwitch()
//                switchView.isOn = true
//                cell.accessoryView = switchView
//            } else if indexPath.row == 1 {
//                cell.textLabel?.text = "Recomendação de atividades"
//                let switchView = UISwitch()
//                switchView.isOn = true
//                cell.accessoryView = switchView
//            } else if indexPath.row == 2 {
//                cell.textLabel?.text = "Intervalo Curto"
//                cell.accessoryType = .disclosureIndicator
//            } else if indexPath.row <= 2 + shortBreakActivities.count {
//                cell.textLabel?.text = shortBreakActivities[indexPath.row - 3]
//            } else if indexPath.row == 3 + shortBreakActivities.count {
//                cell.textLabel?.text = "Intervalo Longo"
//                cell.accessoryType = .disclosureIndicator
//            } else {
//                cell.textLabel?.text = longBreakActivities[indexPath.row - 4 - shortBreakActivities.count]
//            }
//            
//        case 3:
//            if indexPath.row == 0 {
//                cell.textLabel?.text = "Cor"
//                cell.accessoryType = .disclosureIndicator
//            } else if indexPath.row == 1 {
//                cell.textLabel?.text = "Ícone"
//                cell.accessoryType = .disclosureIndicator
//            } else {
//                cell.textLabel?.text = "Papel de parede"
//                cell.accessoryType = .disclosureIndicator
//            }
//            
//        default:
//            break
//        }
//        
//        return cell
//    }
//    
//    // MARK: - Editing Rows
//    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return indexPath.section == 2 && (indexPath.row > 2 && indexPath.row <= 2 + shortBreakActivities.count || indexPath.row > 3 + shortBreakActivities.count)
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            if indexPath.row <= 2 + shortBreakActivities.count {
//                shortBreakActivities.remove(at: indexPath.row - 3)
//            } else {
//                longBreakActivities.remove(at: indexPath.row - 4 - shortBreakActivities.count)
//            }
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
//    
//    // MARK: - Add New Activity
//    
//    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        if indexPath.section == 2 {
//            let alert = UIAlertController(title: "Adicionar Atividade", message: "Digite o nome da nova atividade", preferredStyle: .alert)
//            alert.addTextField()
//            let addAction = UIAlertAction(title: "Adicionar", style: .default) { [weak self] _ in
//                guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
//                if indexPath.row == 2 {
//                    self?.shortBreakActivities.append(text)
//                } else if indexPath.row == 3 + self!.shortBreakActivities.count {
//                    self?.longBreakActivities.append(text)
//                }
//                self?.tableView.reloadData()
//            }
//            alert.addAction(addAction)
//            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
//            present(alert, animated: true)
//        }
//    }
//    
//    // MARK: - Table View Header Titles
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0: return "NOTIFICAÇÕES"
//        case 1: return "Atividades Personalizadas"
//        case 2: return "SUGESTÕES"
//        case 3: return "APARÊNCIA"
//        default: return nil
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        if section == 1 {
//            return "Aqui você pode adicionar suas próprias atividades personalizadas e desativar nossas recomendações"
//        }
//        return nil
//    }
//}
//#Preview{
//    SettingsViewController()
//}
