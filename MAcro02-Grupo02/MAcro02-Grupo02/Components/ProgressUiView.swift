//
//  ProgressUiView.swift
//  MAcro02-Grupo02
//
//  Created by Felipe Porto on 01/11/24.
//

import UIKit

class ProgressUiView: UIView {
    
    private var currentProgress:Float = 0.0
    var function: ((Any) -> Void)?
    
    private var progressBar:UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = AppColors.progressPrimary
        progressView.progressTintColor = AppColors.progressSecundary
        progressView.isHidden = true
                
        return progressView
    }()
    
    var label:UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = AppFonts.regular
        label.textColor = AppColors.textPrimary
        
        label.text = NSLocalizedString("Mantenha pressionado para pular", comment: "Tela de respiração") 
        
        label.layer.opacity = 0.5
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        
        self.addSubview(progressBar)
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            progressBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            progressBar.widthAnchor.constraint(equalTo: label.widthAnchor, constant: -10),
            
            label.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func updateProgress() {
        
        guard currentProgress < 1 else { return }
        guard let function else { return }
        
        progressBar.isHidden = false
        currentProgress += 0.1
        progressBar.setProgress(currentProgress, animated: true)
        
        label.layer.opacity = 1
        
        if currentProgress > 0.99 {
            function(self)
        }
            
    }
    
    func resetProgress() {
        currentProgress = 0.0
        progressBar.isHidden = true
        progressBar.setProgress(currentProgress, animated: false)
        label.layer.opacity = 0.5
    }

}
