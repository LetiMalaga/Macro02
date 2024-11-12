////
////  ActivitiesViewController.swift
////  MAcro02-Grupo02
////
////  Created by Luiz Felipe on 17/09/24.
////
//
//import UIKit
//import CloudKit
//
//protocol ActivitiesViewProtocol: AnyObject {
//    var activities: [ActivitiesModel] { get set }
//    var selectededActivity: ActivitiesModel? {get set}
//    
//    func reloadData()
//    func showActivityDetail(_ activity: ActivitiesModel)
//}
//
////------------------------------------------------------------------------------------------------------
//
//class ActivitiesViewController: UIViewController
//{
//    
//    var ActivityScreen: ActivitiesScreen = ActivitiesScreen()
//    var interactor: ActivitiesInteractorProtocol?
//    var activities: [ActivitiesModel] = []
//    var selectededActivity: ActivitiesModel?
//    
//    private var editableTable: Int?
//
//    
//    override func loadView() {
//        view = ActivityScreen
//    }
//
//        
//        override func viewDidLoad() {
//            super.viewDidLoad()
//        
//            ActivityScreen.activitiesTable.delegate = self
//            ActivityScreen.activitiesTable.dataSource = self
//             
//            // Carregar atividades
//            interactor?.fetchActivities()
//            iCloudLogin().checkiCloudAccountStatus(from: self)
//        }
//    
//
//    @objc func saveTasks() {}
//    @objc func deleteTasks() {}
//}
//
//extension ActivitiesViewController: UITableViewDelegate, UITableViewDataSource ,ActivitiesViewProtocol{
//    func reloadData() {
//        ActivityScreen.activitiesTable.reloadData()
//    }
//    
//    func showActivityDetail(_ activity: ActivitiesModel) {
//        print("show activity detail")
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        activities.count + 1
//    }
//    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        
//        if indexPath.row == 0 {
//               return false
//           }
//        
//        return indexPath.section == editableTable
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row > 0 {
//            interactor?.getActivity(at: indexPath.row - 1)
//        }
//    }
//    
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
//            let cell = UITableViewCell(style: .default, reuseIdentifier: "titleCell")
//            cell.textLabel?.text = indexPath.section == 0 ? "Intervalo Curto" : "Intervalo Longo"
//            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 22)
//
//            let editButton = UIButton(type: .system)
//            let isEditingThisSection = editableTable == indexPath.section
//            editButton.setTitle(isEditingThisSection ? "Pronto" : "Editar", for: .normal)
//            editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
//            editButton.translatesAutoresizingMaskIntoConstraints = false
//            editButton.tag = indexPath.section
//            cell.contentView.addSubview(editButton)
//
//            NSLayoutConstraint.activate([
//                editButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
//                editButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
//            ])
//
//            return cell
//        } else {
//            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
//            let activity = activities[indexPath.row - 1] // -1 para ignorar o título
//                    cell.textLabel?.text = activity.tittle
//                    cell.accessoryType = .detailButton
//                    return cell
//        }
//    }
//
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        56
//    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        20
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        60
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView()
//        footerView.backgroundColor = .clear
//        return footerView
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            interactor?.deleteActivity(at: indexPath.row - 1)
//        }
//    }
//    
//    
//    @objc func editButtonTapped(_ sender: UIButton) {
//        let section = sender.tag
//        
//        if let eT = editableTable {
//            if eT == section {
//                editableTable = nil
//                ActivityScreen.activitiesTable.setEditing(false, animated: true)
//            } else {
//                editableTable = section
//                ActivityScreen.activitiesTable.setEditing(true, animated: true)
//            }
//        } else {
//            editableTable = section
//            ActivityScreen.activitiesTable.setEditing(true, animated: true)
//        }
//        
//        ActivityScreen.activitiesTable.reloadData()
//    }
//    
//}
