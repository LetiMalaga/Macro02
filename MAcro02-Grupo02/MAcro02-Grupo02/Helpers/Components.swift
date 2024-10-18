//
//  Components.swift
//  MAcro02-Grupo02
//
//  Created by Letícia Malagutti on 18/10/24.
//

import UIKit

class ComponenteOndeVoceSeEncontraViewController: UIViewController {
    private let bgRectangleCompOVSE = UIView();
    private let bgRectangleAtHomeButton = UIView();
    private let bgRectangleNotHomeButton = UIView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        setupComponents()
        setupConstraints()
    }
    
    private func setupComponents(){
        //Background Rectangle
        bgRectangleCompOVSE.center = view.center
        bgRectangleCompOVSE.backgroundColor = .systemGray
        bgRectangleCompOVSE.layer.cornerRadius = 35
        
        //Background Button Rectangles
        bgRectangleAtHomeButton.center = view.center
        bgRectangleAtHomeButton.backgroundColor = .white
        bgRectangleAtHomeButton.layer.cornerRadius = 20
        
    }
    
    private func setupConstraints() {
        let subviews = [bgRectangleCompOVSE, bgRectangleAtHomeButton, bgRectangleNotHomeButton]
        subviews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Background Rectangle Constraints
            bgRectangleCompOVSE.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bgRectangleCompOVSE.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            bgRectangleCompOVSE.heightAnchor.constraint(equalToConstant: view.bounds.height * .bgRectangleCompOVSE),
            
            bgRectangleCompOVSE.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            bgRectangleCompOVSE.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            // Background Button Rectangles
            bgRectangleAtHomeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            bgRectangleAtHomeButton.bottomAnchor.constraint(equalTo: bgRectangleCompOVSE.bottomAnchor, constant: -20),
            
            bgRectangleAtHomeButton.widthAnchor.constraint(equalToConstant: bgRectangleCompOVSE.bounds.width * .bgButtonRectangle),
            
            bgRectangleNotHomeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            bgRectangleNotHomeButton.bottomAnchor.constraint(equalTo: bgRectangleAtHomeButton.bottomAnchor, constant: -20),
            
            bgRectangleNotHomeButton.widthAnchor.constraint(equalToConstant: bgRectangleCompOVSE.bounds.width * .bgButtonRectangle),
            
        ])
    }
    
}


#Preview {
    ComponenteOndeVoceSeEncontraViewController()
}

extension Double{
    public static let bgRectangleCompOVSE = 0.34
    public static let bgButtonRectangle = 0.8
}
