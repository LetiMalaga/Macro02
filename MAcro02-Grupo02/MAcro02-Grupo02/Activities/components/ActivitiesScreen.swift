//
//  Activitiesscreen.swift
//  MAcro02-Grupo02
//
//  Created by Felipe Porto on 23/09/24.
//


import UIKit

protocol ActivitiesProtocol: AnyObject {
    func saveButton()
}

class ActivitiesScreen: UIView {
    
    private weak var delegate: ActivitiesProtocol?
    private var editableTable: Int?
    
    public func delegate(_ delegate: ActivitiesProtocol) {
        self.delegate = delegate
    }
    
    lazy var activityTitle: UILabel = {
        let label = UILabel()
        label.text = "Intervalos"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Salvar", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var activitiesTable: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isScrollEnabled = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func editButtonTapped(_ sender: UIButton) {
        let section = sender.tag
        
        if let eT = editableTable {
            if eT == section {
                editableTable = nil
                activitiesTable.setEditing(false, animated: true)
            } else {
                editableTable = section
                activitiesTable.setEditing(true, animated: true)
            }
        } else {
            editableTable = section
            activitiesTable.setEditing(true, animated: true)
        }
        
        activitiesTable.reloadData()
    }
    
    private func setupView() {
        addSubview(activityTitle)
        addSubview(saveButton)
        addSubview(activitiesTable)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            activityTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            activityTitle.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            saveButton.bottomAnchor.constraint(equalTo: activityTitle.bottomAnchor),
            saveButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            activitiesTable.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            activitiesTable.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            activitiesTable.topAnchor.constraint(equalTo: activityTitle.bottomAnchor, constant: 20),
            activitiesTable.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

extension ActivitiesScreen: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.row == 0 {
               return false
           }
        
        return indexPath.section == editableTable
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "titleCell")
            cell.textLabel?.text = indexPath.section == 0 ? "Intervalo Curto" : "Intervalo Longo"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 22)

            let editButton = UIButton(type: .system)
            let isEditingThisSection = editableTable == indexPath.section
            editButton.setTitle(isEditingThisSection ? "Pronto" : "Editar", for: .normal)
            editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
            editButton.translatesAutoresizingMaskIntoConstraints = false
            editButton.tag = indexPath.section
            cell.contentView.addSubview(editButton)

            NSLayoutConstraint.activate([
                editButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                editButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])

            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = "Atividade \(indexPath.row)"
            cell.accessoryType = .detailButton
            return cell
        }
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        56
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        if indexPath.row == 0 {
            return .none
        }
        
        return indexPath.section == editableTable ? .delete : .none
        
    }
}
