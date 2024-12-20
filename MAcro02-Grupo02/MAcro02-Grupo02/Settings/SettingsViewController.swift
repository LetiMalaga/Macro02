//
//  SettingsViewController.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 01/11/24.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, SettingsViewProtocol {
    var soundButton: Bool = UserDefaults.standard.bool(forKey: "sound") {
        didSet { soundSwitch.isOn = soundButton }
    }
    
    var vibrationButton: Bool = UserDefaults.standard.bool(forKey: "vibration") {
        didSet { vibrationSwitch.isOn = vibrationButton }
    }
    
    var breathingButton: Bool = UserDefaults.standard.bool(forKey: "breathing") {
        didSet { breathingSwitch.isOn = breathingButton }
    }
    
    var recommendationButton: Bool = UserDefaults.standard.bool(forKey: "recomendations") {
        didSet { recommendationSwitch.isOn = recommendationButton }
    }
    
    var defaultActivitiesButton: Bool = UserDefaults.standard.bool(forKey: "defaultActivities") {
        didSet { defaultActivitiesSwitch.isOn = defaultActivitiesButton }
    }
    
    var shortBreakActivities: [ActivitiesModel] = []
    
    var longBreakActivities: [ActivitiesModel] = []
    
    var activities: [ActivitiesModel] = [] {
        didSet { reloadData()}
    }
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let soundSwitch = UISwitch()
    private let vibrationSwitch = UISwitch()
    private let breathingSwitch = UISwitch()
    private let recommendationSwitch = UISwitch()
    private let defaultActivitiesSwitch = UISwitch()
    var tags:[String] = []
    var editableSections: Set<Int> = []
    
    
    var interactor: SettingsIteractorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Ajustes", comment: "Settings")
        view.backgroundColor = .customBGColor
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        interactor?.fetchActivities(isCSV: false)
        interactor?.fetchTags()
        
        setupTableView()
        reloadData()
    }
    
    func reloadData() {
        
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ColorIconCell")
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
    
    @objc func defaultActivitiesSwitchChanged(_ sender: UISwitch) {
        interactor?.changeDefaultActivities()
    }
}


extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6 // APP, Sugestões, Atividades Personalizadas, Intervalo Curto, Intervalo Longo, Aparência
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2 // Sons e Vibrações
        case 1:
            return 0 // Botão "Editar"
        case 2:
            return 3 // Respiração ao iniciar, Recomendação de atividades, Atividades Padrão
        case 3:
            return shortBreakActivities.count + 1 // Atividades de intervalo curto + opção para adicionar
        case 4:
            return longBreakActivities.count + 1 // Atividades de intervalo longo + opção para adicionar
//        case 5:
//            return 2
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
                cell.textLabel?.text = NSLocalizedString("Sons", comment: "Settings")
                soundSwitch.isOn = soundButton
                soundSwitch.addTarget(self, action: #selector(soundSwitchChanged(_:)), for: .valueChanged)
                soundSwitch.onTintColor = .customAccentColor
                cell.accessoryView = soundSwitch
            } else {
                cell.textLabel?.text = NSLocalizedString("Vibrações", comment: "Settings")
                vibrationSwitch.isOn = vibrationButton
                vibrationSwitch.addTarget(self, action: #selector(vibrationSwitchChanged(_:)), for: .valueChanged)
                vibrationSwitch.onTintColor = .customAccentColor
                cell.accessoryView = vibrationSwitch
            }
            return cell
            
            
        case 1:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "EditCell")
            cell.textLabel?.text = tableView.isEditing ? NSLocalizedString("Concluir", comment: "Settings") : NSLocalizedString("Editar", comment: "Settings")
            cell.textLabel?.textColor = .customAccentColor
            cell.textLabel?.textAlignment = .right
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath)
            if indexPath.row == 0 {
                cell.textLabel?.text = NSLocalizedString("Respiração ao iniciar Pomodoro", comment: "Settings")
                breathingSwitch.isOn = breathingButton
                breathingSwitch.addTarget(self, action: #selector(breathingSwitchChanged(_:)), for: .valueChanged)
                breathingSwitch.onTintColor = .customAccentColor
                cell.accessoryView = breathingSwitch
            } else if indexPath.row == 1 {
                cell.textLabel?.text = NSLocalizedString("Recomendação de Atividades", comment: "Settings")
                recommendationSwitch.isOn = recommendationButton
                recommendationSwitch.addTarget(self, action: #selector(recommendationSwitchChanged(_:)), for: .valueChanged)
                recommendationSwitch.onTintColor = .customAccentColor
                cell.accessoryView = recommendationSwitch
            } else if indexPath.row == 2 {
                cell.textLabel?.text = NSLocalizedString("Atividades Padrão", comment: "Settings")
                defaultActivitiesSwitch.isOn = defaultActivitiesButton
                defaultActivitiesSwitch.addTarget(self, action: #selector(defaultActivitiesSwitchChanged(_:)), for: .valueChanged)
                defaultActivitiesSwitch.onTintColor = .customAccentColor
                cell.accessoryView = defaultActivitiesSwitch
            }
            return cell
            
            //            let cell = UITableViewCell(style: .default, reuseIdentifier: "EditCell")
            //            cell.textLabel?.text = tableView.isEditing ? "Concluir" : "Editar"
            //            cell.textLabel?.textColor = .systemBlue
            //            cell.textLabel?.textAlignment = .center
            //            return cell
            
        case 3:
            
            if indexPath.row == shortBreakActivities.count {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)
                cell.textLabel?.text = NSLocalizedString("+ Adicione uma atividade de descanso curto", comment: "Settings")
                cell.textLabel?.textColor = .customAccentColor
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(withText: shortBreakActivities[indexPath.row].description, tagText: shortBreakActivities[indexPath.row].tag)
                return cell
            }
            
        case 4:
            if indexPath.row < longBreakActivities.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(withText: longBreakActivities[indexPath.row].description, tagText: longBreakActivities[indexPath.row].tag)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)
                cell.textLabel?.text = NSLocalizedString("+ Adicione uma atividade de descanso longo", comment: "Settings")
                cell.textLabel?.textColor = .customAccentColor
                return cell
            }
//        case 5:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ColorIconCell", for: indexPath)
//            cell.selectionStyle = .gray
//            if indexPath.row == 0 {
//                cell.textLabel?.text = NSLocalizedString("Cor", comment: "Settings")
//                let circleView = UIView()
//                circleView.translatesAutoresizingMaskIntoConstraints = false
//                circleView.backgroundColor = .blue // Cor do círculo
//                circleView.layer.cornerRadius = 15 // Define o raio (para um círculo de 20x20)
//                circleView.layer.masksToBounds = true
//                let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
//                chevronImageView.translatesAutoresizingMaskIntoConstraints = false
//                chevronImageView.tintColor = .systemGray
//                
//                // Adiciona o círculo à célula
//                cell.contentView.addSubview(circleView)
//                cell.contentView.addSubview(chevronImageView)
//                
//                // Configura constraints para posicionar o círculo
//                NSLayoutConstraint.activate([
//                    circleView.widthAnchor.constraint(equalToConstant: 30),
//                    circleView.heightAnchor.constraint(equalToConstant: 30),
//                    circleView.centerYAnchor.constraint(equalTo: cell.textLabel!.centerYAnchor),
//                    circleView.leadingAnchor.constraint(equalTo: cell.textLabel!.trailingAnchor, constant: -35),
//                    
//                    chevronImageView.centerYAnchor.constraint(equalTo: cell.textLabel!.centerYAnchor),
//                    chevronImageView.leadingAnchor.constraint(equalTo: cell.textLabel!.trailingAnchor),
//                    
//                ])
//            } else {
//                cell.textLabel?.text = NSLocalizedString("Ícone", comment: "Settings")
//                let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
//                chevronImageView.translatesAutoresizingMaskIntoConstraints = false
//                chevronImageView.tintColor = .systemGray
//                
//                // Adiciona o círculo à célula
//                cell.contentView.addSubview(chevronImageView)
//                
//                // Configura constraints para posicionar o círculo
//                NSLayoutConstraint.activate([
//                    chevronImageView.centerYAnchor.constraint(equalTo: cell.textLabel!.centerYAnchor),
//                    chevronImageView.leadingAnchor.constraint(equalTo: cell.textLabel!.trailingAnchor),
//                    
//                ])
//            }
//            return cell
//            
//            
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
            
            titleLabel.text = NSLocalizedString("Atividades Personalizadas", comment: "Settings")
            titleLabel.font = .preferredFont(forTextStyle: .headline)
            
            
        case 2:
            titleLabel.text = NSLocalizedString("Sugestões", comment: "Settings")
            titleLabel.textColor = .gray
            let descriptionLabel = UILabel()
            descriptionLabel.font = .preferredFont(forTextStyle: .caption1)
            descriptionLabel.textColor = .gray
            descriptionLabel.numberOfLines = 0
            descriptionLabel.text = NSLocalizedString("Aqui você pode adicionar suas próprias atividades personalizadas e desativar nossas recomendações", comment: "Settings")
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            headerView.addSubview(descriptionLabel)
            
            NSLayoutConstraint.activate([
                
                descriptionLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -50),
                descriptionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
                descriptionLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
                
            ])
            
        case 3:
            titleLabel.text = NSLocalizedString("Intervalo Curto", comment: "Settings")
            titleLabel.textColor = .gray
            
            makeButton()
            
        case 4:
            titleLabel.text = NSLocalizedString("Intervalo Longo", comment: "Settings")
            titleLabel.textColor = .gray
            
            makeButton()
//        case 5:
//            titleLabel.text = NSLocalizedString("Aparência", comment: "Settings")
//            titleLabel.textColor = .gray
//            
            
        default:
            titleLabel.text = ""
        }
        
        func font(_ title:String) -> UITableViewHeaderFooterView?{
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeader")
            header?.textLabel?.textColor = .customText
            header?.textLabel?.text = title
            header?.textLabel?.font = .preferredFont(forTextStyle: .title3)
            
            return header
        }
        func makeButton(){
            let button = UIButton(type: .system)
            button.setTitle(tableView.isEditing ? NSLocalizedString("Concluir", comment: "Settings") : NSLocalizedString("Editar", comment: "Settings"), for: .normal)
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
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: section == 0 || section == 2 ? 20 : 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            
            headerView.heightAnchor.constraint(equalToConstant: section == 2 ? 60 : 40)
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
        } else if indexPath.section == 3 {
            let selectedActivity = shortBreakActivities[indexPath.row]
            presentActivityDetail(for: selectedActivity)
        } else if indexPath.section == 4 {
            let selectedActivity = longBreakActivities[indexPath.row]
            presentActivityDetail(for: selectedActivity)
        }
//        else if indexPath.section == 5 && indexPath.row == 0{
//            presentColor()
//        }else if indexPath.section == 5 && indexPath.row == 1{
//            //MARK: icon
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    private func presentActivityDetail(for activity: ActivitiesModel) {
        let detailVC = ActivityDetailViewController()
        detailVC.activity = activity
        detailVC.interactor = self.interactor
        detailVC.tags = self.tags
        
        detailVC.onSave = { [weak self] updatedActivity in
            self?.updateActivity(updatedActivity)
        }
        detailVC.modalPresentationStyle = .fullScreen
        present(detailVC, animated: true, completion: nil)
        
    }
    
    func presentNewActivity(type: ActivitiesType) {
        let newActivityVC = NewActivityViewController()
        newActivityVC.activityType = type
        newActivityVC.interactor = self.interactor
        newActivityVC.tags = self.tags
        
        newActivityVC.modalPresentationStyle = .fullScreen
        present(newActivityVC, animated: true, completion: nil)
    }
    
    private func presentColor(){
        let selectorColorVC = SelectorColorBaseViewController()
        
        selectorColorVC.modalPresentationStyle = .fullScreen
        present(selectorColorVC, animated: true, completion: nil)
    }
    
    private func updateActivity(_ updatedActivity: ActivitiesModel) {
        interactor?.updateActivity(updatedActivity)
        
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
                let id = shortBreakActivities[indexPath.row].id
                interactor?.deleteActivity(at: id)
            } else if indexPath.section == 4 {
                let id = longBreakActivities[indexPath.row].id
                interactor?.deleteActivity(at: id)
            }
        }
    }
}

class CustomTableViewCell: UITableViewCell {
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.customText
        label.numberOfLines = 0
        return label
    }()
    
    let tagLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.customText
        label.backgroundColor = .customBGColor
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        label.textAlignment = .center
        label.padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(mainLabel)
        contentView.addSubview(tagLabel)
        
        // Definindo prioridades de hugging e resistência à compressão para manter o tamanho de tagLabel
        tagLabel.setContentHuggingPriority(.required, for: .horizontal)
        tagLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        // Constraints para o mainLabel
        NSLayoutConstraint.activate([
            mainLabel.leadingAnchor.constraint(equalTo: tagLabel.trailingAnchor, constant: 10),
            mainLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            mainLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        
        // Constraints para o tagLabel
        NSLayoutConstraint.activate([
            tagLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tagLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tagLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 50), // largura mínima
            tagLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(withText text: String, tagText: String) {
        mainLabel.text = text
        mainLabel.numberOfLines = 1 // Limita a uma linha
        mainLabel.lineBreakMode = .byTruncatingTail // Adiciona "..." no final quando o texto é cortado
        mainLabel.adjustsFontSizeToFitWidth = false // Não ajusta o tamanho da fonte
        tagLabel.text = tagText
        tagLabel.numberOfLines = 1 // Limita a uma linha
        tagLabel.lineBreakMode = .byTruncatingTail // Adiciona "..." no final quando o texto é cortado
        tagLabel.adjustsFontSizeToFitWidth = false // Não ajusta o tamanho da fonte
    }
}

class PaddedLabel: UILabel {
    var padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    
    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: padding)
        super.drawText(in: insetRect)
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}

#Preview{
    SettingsViewController()
}
