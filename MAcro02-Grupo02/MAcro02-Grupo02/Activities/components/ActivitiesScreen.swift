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

class ActivitiesScreen: UIView{
    
    private weak var delegate: ActivitiesProtocol?
    
    public func delegate(_ delegate: ActivitiesProtocol) {
        self.delegate = delegate
    }
    
    lazy var activityTitle: UILabel = {
        let label = UILabel()
        label.text = "Intervalos"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = UIColor.customText
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
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isScrollEnabled = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        backgroundColor = .customBGColor
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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


