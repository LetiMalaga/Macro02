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
        view.backgroundColor = .customBGColor
        
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
        collectionView.backgroundColor = .customBGColor // Definindo a cor de fundo para a UICollectionView
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
    let minutesLabel = UILabel()
    let secondsLabel = UILabel()
    let colonLabel = UILabel()
    let arrowImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        // Título
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        // Estilizando os labels para minutos e segundos
        setupTimeLabel(minutesLabel)
        setupTimeLabel(secondsLabel)
        
        // Dois pontos ":"
        colonLabel.translatesAutoresizingMaskIntoConstraints = false
        colonLabel.text = ":"
        colonLabel.textColor = .label
        colonLabel.font = UIFont.boldSystemFont(ofSize: 64)
        colonLabel.textAlignment = .center
        contentView.addSubview(colonLabel)
        
        // Seta para indicar a possibilidade de ajustar (seta à direita)
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = .lightGray
        contentView.addSubview(arrowImageView)
        
        // Adicionando os labels à célula
        contentView.addSubview(minutesLabel)
        contentView.addSubview(secondsLabel)

        // Adicionando constraints
        NSLayoutConstraint.activate([
            // Título na parte superior
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            // Minutos label (à esquerda)
            minutesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            minutesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            minutesLabel.widthAnchor.constraint(equalToConstant: 104),
            minutesLabel.heightAnchor.constraint(equalToConstant: 80),
            
            // Dois pontos ":" no meio
            colonLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            colonLabel.leadingAnchor.constraint(equalTo: minutesLabel.trailingAnchor, constant: 10),
            colonLabel.widthAnchor.constraint(equalToConstant: 15),
            
            // Segundos label (à direita dos dois pontos)
            secondsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            secondsLabel.leadingAnchor.constraint(equalTo: colonLabel.trailingAnchor, constant: 10),
            secondsLabel.widthAnchor.constraint(equalToConstant: 104),
            secondsLabel.heightAnchor.constraint(equalToConstant: 80),

            // Seta à direita da célula
            arrowImageView.centerYAnchor.constraint(equalTo: minutesLabel.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Inicialmente escondendo o campo de segundos
        secondsLabel.isHidden = false
        colonLabel.isHidden = false
    }
    
    // Função para estilizar os labels de minutos e segundos
    func setupTimeLabel(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 64)
        label.textAlignment = .center
        label.textColor = .label
        label.layer.borderColor = UIColor.label.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
    }

    // Função para configurar os valores (minutos e segundos)
    func configure(title: String, seconds: Int) {
        titleLabel.text = title
        minutesLabel.text = String(seconds) // Converte segundos em minutos
        
        // Se for Ciclos Pomodoro, esconder segundos
        if title == NSLocalizedString("Ciclos de Pomodoro", comment: "SelectorViewController") {
            secondsLabel.isHidden = true
            colonLabel.isHidden = true
            minutesLabel.text = "\(seconds)"
            
            NSLayoutConstraint.activate([arrowImageView.trailingAnchor.constraint(equalTo: minutesLabel.trailingAnchor, constant: 40)])
        } else {
            secondsLabel.isHidden = false
            colonLabel.isHidden = false
            secondsLabel.text = "00"
            
            NSLayoutConstraint.activate([arrowImageView.trailingAnchor.constraint(equalTo: secondsLabel.trailingAnchor, constant: 40)])
        }
    }
}
