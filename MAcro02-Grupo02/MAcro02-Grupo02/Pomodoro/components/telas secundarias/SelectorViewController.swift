import UIKit

enum ConfigType {
    case foco
    case intervaloCurto
    case intervaloLongo
    case ciclosPomodoro
}

class SelectorViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var pomoDefaults = PomoDefaults()
    var collectionView: UICollectionView!
    
//    let titleLabel: UILabel = {
//        
//        let titleLabel = UILabel()
//        titleLabel.text = "Personalização"
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 34)
//        titleLabel.textColor = .black
//        
//        return titleLabel
//        
//    }()
    

    
    let saveButton: PomoButton = {
        
        let button = PomoButton(frame: CGRect(x: 0, y: 0, width: 290, height: 60), titulo: NSLocalizedString("Salvar", comment: "SelectorViewController"))
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        return button

    }()

    var configs: [(type: ConfigType, title: String, seconds: Int)] = [
        (.foco, NSLocalizedString("Foco", comment: "SelectorViewController"), 0),
        (.intervaloCurto, NSLocalizedString("Intervalo Curto", comment: "SelectorViewController"), 0),
        (.intervaloLongo, NSLocalizedString("Intervalo Longo", comment: "SelectorViewController"), 0),
        (.ciclosPomodoro, NSLocalizedString("Ciclos de Pomodoro", comment: "SelectorViewController"), 0)
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        // Definindo cor de fundo da view principal
        view.backgroundColor = .systemBackground
        
        print(pomoDefaults.workDuration)
        print(pomoDefaults.breakDuration)
        print(pomoDefaults.longBreakDuration)
        
        
        let workDuration = pomoDefaults.workDuration
        let breakDuration = pomoDefaults.breakDuration
        let longBreakDuration = pomoDefaults.longBreakDuration
        let loops = pomoDefaults.loops
        
        // Atualizando os valores com base em PomoDefaults
        configs[0].seconds = workDuration
        configs[1].seconds = breakDuration
        configs[2].seconds = longBreakDuration
        configs[3].seconds = loops
        
        setupCollectionView()
        setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Personalização", comment: "SelectorViewController")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Voltar", comment: "SelectorViewController"), style: .plain, target: nil, action: nil)
    }
    
    func setupView() {
        

        view.addSubview(collectionView)
        view.addSubview(saveButton)
        

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -10),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            
        ])
        
        
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 40, height: 150) // Aumentando a altura para o título
        layout.minimumLineSpacing = -10 // Espaçamento entre as células

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground // Definindo a cor de fundo para a UICollectionView
        collectionView.register(ConfigCell.self, forCellWithReuseIdentifier: "ConfigCell")
    }
    
    // Ação do botão "Salvar"
    @objc func saveButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UICollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return configs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConfigCell", for: indexPath) as! ConfigCell
        let config = configs[indexPath.item]
        cell.configure(title: config.title, seconds: config.seconds)
        return cell
    }

    // Ação ao selecionar uma célula
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let config = configs[indexPath.item]
        
        let vc = TimeSelectorViewController(title: config.title, type: config.type, atualTime: config.seconds)
        navigationController?.pushViewController(vc, animated: true)
    }
}


class ConfigCell: UICollectionViewCell {
    
    let titleLabel = UILabel()
    let pomoTime: PomoSelectorUIVIew = PomoSelectorUIVIew(NumText: "")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        pomoTime.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(pomoTime)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            pomoTime.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            pomoTime.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
        ])
        
        
    }

    // Função para configurar os valores (minutos e segundos)
    func configure(title: String, seconds: Int) {
        titleLabel.text = title
        pomoTime.NumText = String(format: title == "Ciclos de Pomodoro" ? "%02d" : "%02d:00", seconds) // Converte segundos em minutos
        
        pomoTime.widthAnchor.constraint(equalToConstant: title == NSLocalizedString("Ciclos de Pomodoro", comment: "SelectorViewController") ? 155 : 251).isActive = true
    }
}