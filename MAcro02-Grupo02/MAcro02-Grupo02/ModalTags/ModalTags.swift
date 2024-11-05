//
//  ModalTags.swift
//  MAcro02-Grupo02
//
//  Created by Letícia Malagutti on 22/10/24.
//

import UIKit

class ModalTagsViewController: UIViewController {
    
    private let modalView = UIView()
    private let modalActivationButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        self.modalActivationButton.addTarget(self, action: #selector(openModal), for: .touchUpInside)
    }
    
    func setupView() {
        view.backgroundColor = .systemRed
        configureSheet()
        setupButton()
        setupConstraints()
    }
    
    func configureSheet(){
        //Modal size and info
//        let vc = SheetViewController()
        let vc = ModalTagsFactory.makeModalTags()
        let navVC = UINavigationController(rootViewController: vc)
//        
//        if let sheet = navVC.sheetPresentationController {
//            sheet.detents = [.custom(resolver: { context in
//                0.3 * context.maximumDetentValue
//            })]
//        }
        
//        navigationController?.present(navVC, animated: true)
    }
    
    func setupButton(){
        modalActivationButton.setTitle("Open Modal", for: .normal)
        modalActivationButton.setTitleColor(.white, for: .normal)
        modalActivationButton.titleLabel?.font = .systemFont(ofSize: 64)
        modalActivationButton.backgroundColor = .blue
        modalActivationButton.center = view.center
        
    }
    
    private func setupConstraints() {
        let subviews = [modalView, modalActivationButton]
        subviews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Background Top Rectangle Constraints
            modalActivationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            modalActivationButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            modalActivationButton.heightAnchor.constraint(equalToConstant: view.bounds.height * .modalViewHeightCtt),
            
            modalActivationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            modalActivationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

        ])
    }
    @objc private func openModal(){
        
        let vc = SheetViewController()
        let navVC = UINavigationController(rootViewController: vc)
        
        
        if let sheet = navVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                context.maximumDetentValue * .modalViewHeightCtt
            }), .medium(), .large()]
        }
        navigationController?.present(navVC, animated: true)
    }
        
    
}

#Preview{
    ModalTagsViewController()
}

extension Double {
    public static let modalViewHeightCtt = 0.37
}
