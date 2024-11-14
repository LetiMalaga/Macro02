//
//  TagModalsViewController.swift
//  MAcro02-Grupo02
//
//  Created by Felipe Porto on 09/10/24.
//

import UIKit

class TagModalsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .customBGColor
        view.layer.cornerRadius = 35
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        let label = UILabel()
        label.text = NSLocalizedString("Trabalho", comment: "Modal de Tags")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

class CustomPresentationController: UIPresentationController {
    
    private var dimmingView: UIView!
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: UIScreen.main.bounds.height - 300, width: UIScreen.main.bounds.width, height: 300)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        // Cria a view de escurecimento
        dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView.alpha = 0
        containerView.addSubview(dimmingView)
        
        // Adiciona um gesto de toque para fechar a modal
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        dimmingView.addGestureRecognizer(tapGesture)

        // Anima a aparição da view de escurecimento
        UIView.animate(withDuration: 0.3) {
            self.dimmingView.alpha = 1
        }
    }

    override func dismissalTransitionWillBegin() {
        // Anima a remoção da view de escurecimento
        UIView.animate(withDuration: 0.3) {
            self.dimmingView.alpha = 0
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }

    @objc private func dismissModal() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        // Configura a dimmingView para preencher a tela
        dimmingView.frame = containerView!.bounds
    }
}
