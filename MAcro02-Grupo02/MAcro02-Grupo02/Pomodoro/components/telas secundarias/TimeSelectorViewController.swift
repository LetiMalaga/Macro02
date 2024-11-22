//
//  TimeSelectorViewController.swift
//  MAcro02-Grupo02
//
//  Created by Felipe Porto on 16/10/24.
//

import UIKit

class TimeSelectorViewController: UIViewController {

    // vars

    let titlle:String
    let type:ConfigType
    var time: Int
    var predefinitions:[Int] = []

    // pomodoro

    let pomoDefaults = PomoDefaults()

    // components

    let titleLabel: UILabel = {

        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .customText

        return label

    }()

    let explanationLabel: UILabel = {

        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 4
        label.textColor = .customText

        return label

    }()

    let predefinedLabel: UILabel = {

        let label = UILabel()
        label.text = NSLocalizedString("Tempos predefinidos", comment: "TimeSelectorViewController")
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .customText

        return label

    }()

    let selectorView: PredefinitionButtonsView = {

        let view = PredefinitionButtonsView()
        return view

    }()

    let dentsView: DentsView = {
        let view = DentsView()
        return view
    }()

    private let timeSlider: GearBarView


    let infiniteLabel: UILabel = {

        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        label.text = NSLocalizedString("Com este modo ativado, o pomodoro é contado a partir do 0 e assim prossegue até que você o pare.", comment: "TimeSelectorViewController")
        label.textColor = .customText.withAlphaComponent(0.6)


        return label

    }()

    let saveButton: PomoButton = {
        let button = PomoButton(frame: CGRect(x: 0, y: 0, width: 292, height: 60), titulo: NSLocalizedString("Salvar", comment: "TimeSelectorViewController"))
        button.backgroundColor = .customAccentColor
        button.tintColor = .customAccentColor
        button.setTitleColor(.customTextOpposite, for: .normal)
        button.addTarget(self, action: #selector(save), for: .touchUpInside)

        return button
    }()


    init(title: String, type: ConfigType, atualTime: Int) {

        self.type = type
        self.time = atualTime
        self.titlle = title

        timeSlider = GearBarView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), initialTime: time, cicle: type == .ciclosPomodoro)

        super.init(nibName: nil, bundle: nil)

        titleLabel.text = title
        timeSlider.tintColor = .customAccentColor
//        timeSlider.backgroundColor = .customAccentColor
        timeSlider.isUserInteractionEnabled = true

        switch type {
        case .foco:
            explanationLabel.text = NSLocalizedString("Hora de focar! Escolha o tempo ideal para mergulhar na sua tarefa e bloquear distrações.", comment: "TimeSelectorViewController")

            predefinitions = [15, 25, 45, 60]

        case .intervaloCurto:

            explanationLabel.text = NSLocalizedString("Após um ciclo de foco, o app sugere atividades como alongamentos ou uma respiração profunda para você relaxar e manter o foco renovado.", comment: "TimeSelectorViewController")

            predefinitions = [5, 10, 15, 20]

        case .intervaloLongo:

            explanationLabel.text = NSLocalizedString("Ao completar alguns ciclos de foco, é hora de um intervalo mais longo. Aproveite essa pausa para descansar mais profundamente.", comment: "TimeSelectorViewController")

            predefinitions = [10, 20, 30, 40]

        case .ciclosPomodoro:

            explanationLabel.text = NSLocalizedString("Defina quantos ciclos de foco e intervalos você deseja realizar. O app automatiza essas sessões, permitindo que você se concentre sem precisar se preocupar com os tempos.", comment: "TimeSelectorViewController")

            predefinedLabel.text = NSLocalizedString("Ciclos pre-definidos:", comment: "TimeSelectorViewController")

            predefinitions = [2, 4, 6, 8]

        }

        selectorView.setupButtons(with: predefinitions)
        selectorView.buttonAction = {

            [weak self] selectedValue in

            self?.timeSlider.timeInMinutes = selectedValue

        }

        print(title, type, atualTime)


    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .customBGColor



        setupLayout()

    }

    func setupLayout() {

        view.addSubview(titleLabel)
        view.addSubview(explanationLabel)
        view.addSubview(predefinedLabel)
        view.addSubview(saveButton)
        view.addSubview(timeSlider)
        view.addSubview(selectorView)
        view.addSubview(dentsView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        predefinedLabel.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        timeSlider.translatesAutoresizingMaskIntoConstraints = false
        selectorView.translatesAutoresizingMaskIntoConstraints = false
        dentsView.translatesAutoresizingMaskIntoConstraints = false

        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))

        dentsView.addGestureRecognizer(dragGesture)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),

            explanationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            explanationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            explanationLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -20),
            explanationLabel.widthAnchor.constraint(equalToConstant: 358),

            predefinedLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            predefinedLabel.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor, constant: 40),

            selectorView.topAnchor.constraint(equalTo: predefinedLabel.bottomAnchor, constant: 10),
            selectorView.widthAnchor.constraint(equalToConstant: 328),
            selectorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            timeSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeSlider.topAnchor.constraint(equalTo: selectorView.bottomAnchor, constant: 200),
            timeSlider.widthAnchor.constraint(equalToConstant: 358),
            timeSlider.heightAnchor.constraint(equalToConstant: 32),

            dentsView.topAnchor.constraint(equalTo: timeSlider.bottomAnchor, constant: -50),
            dentsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dentsView.widthAnchor.constraint(equalToConstant: 300),
            dentsView.heightAnchor.constraint(equalToConstant: 32)

        ])

    }

    @objc func save() {

        switch type {
        case .foco:
            pomoDefaults.setTime(for: "workDuration", value: timeSlider.timeInMinutes)
        case .intervaloCurto:
            pomoDefaults.setTime(for: "breakDuration", value: timeSlider.timeInMinutes)
        case .intervaloLongo:
            pomoDefaults.setTime(for: "longBreakDuration", value: timeSlider.timeInMinutes)
        case .ciclosPomodoro:
            pomoDefaults.setTime(for: "loopsQuantity", value: timeSlider.timeInMinutes)
        }

        navigationController?.popViewController(animated: true)
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {

            let translation = gesture.translation(in: dentsView)

        let increment = Int(translation.x / 20) * (type == .ciclosPomodoro ? 1 : 5)

           // Chamando o callback com o incremento
           if increment != 0 {
               timeSlider.updateTime(time: timeSlider.timeInMinutes + increment)
               gesture.setTranslation(.zero, in: dentsView)
           }
       }

}

<<<<<<< HEAD:MAcro02-Grupo02/MAcro02-Grupo02/Pomodoro/components/TimeSelectorViewController.swift
//#Preview{
//    TimeSelectorViewController()
//}
=======
#Preview{
    TimeSelectorViewController(title: "Foco", type: ConfigType.foco, atualTime: 60)
}
>>>>>>> 8f91973a13dd0a9199ee871633265c9e566ea81a:MAcro02-Grupo02/MAcro02-Grupo02/Pomodoro/components/telas secundarias/TimeSelectorViewController.swift
