//
//  SheetViewController.swift
//  MAcro02-Grupo02
//
//  Created by Letícia Malagutti on 22/10/24.
//

import UIKit

class SheetViewController: UIViewController {
    
    private let modalIdentifierLine = UIView()
    private let modalTagLabel = UILabel()
    private let ellipsisButton = UIButton(type: .system)
    private let tagWorkButton = UIButton()
    private let tagStudyButton = UIButton()
    private let tagFocusButton = UIButton()
    private let tagWorkoutButton = UIButton()
    private let tagMeditationButton = UIButton()
    private let tagNewTagButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        view.backgroundColor = .systemBackground
        configureSheet()
        setupButtons()
        setupConstraints()
    }
    
    private func configureSheet(){
        // MARK: Modal Identifier Line
        modalIdentifierLine.center = view.center
        modalIdentifierLine.backgroundColor = .systemGray3
        modalIdentifierLine.layer.cornerRadius = .modalIdentifierLineCornerRadius
        
        // MARK: Label
        modalTagLabel.textColor = .black
        modalTagLabel.text = "Escolha uma Etiqueta"
        modalTagLabel.font = .preferredFont(for: .title2, weight: .bold)
        
        // MARK: Buttons
        ellipsisButton.center = view.center
//        if selectedEllipsisButton {
            
//        } else {
            ellipsisButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
//        }
        ellipsisButton.tintColor = .black
        
        tagWorkButton.center = view.center
        tagWorkButton.layer.borderWidth = 3
        tagWorkButton.layer.borderColor = UIColor.black.cgColor
        tagWorkButton.setTitleColor(.black, for: .normal)
        tagWorkButton.setTitle("Work", for: .normal)
        tagWorkButton.titleLabel?.font = .preferredFont(for: .title2, weight: .bold)
        tagWorkButton.layer.cornerRadius = .tagCornerRadius
        tagWorkButton.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMinYCorner,
            .layerMaxXMaxYCorner
        ]
        
        tagStudyButton.center = view.center
        tagStudyButton.layer.borderWidth = 3
        tagStudyButton.layer.borderColor = UIColor.black.cgColor
        tagStudyButton.setTitleColor(.black, for: .normal)
        tagStudyButton.setTitle("Study", for: .normal)
        tagStudyButton.titleLabel?.font = .preferredFont(for: .title2, weight: .bold)
        tagStudyButton.layer.cornerRadius = .tagCornerRadius
        tagStudyButton.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMinYCorner,
            .layerMaxXMaxYCorner
        ]
        
        tagFocusButton.center = view.center
        tagFocusButton.layer.borderWidth = 3
        tagFocusButton.layer.borderColor = UIColor.black.cgColor
        tagFocusButton.setTitleColor(.black, for: .normal)
        tagFocusButton.setTitle("Focus", for: .normal)
        tagFocusButton.titleLabel?.font = .preferredFont(for: .title2, weight: .bold)
        tagFocusButton.layer.cornerRadius = .tagCornerRadius
        tagFocusButton.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMinYCorner,
            .layerMaxXMaxYCorner
        ]
        
        tagWorkoutButton.center = view.center
        tagWorkoutButton.layer.borderWidth = 3
        tagWorkoutButton.layer.borderColor = UIColor.black.cgColor
        tagWorkoutButton.setTitleColor(.black, for: .normal)
        tagWorkoutButton.setTitle("Workout", for: .normal)
        tagWorkoutButton.titleLabel?.font = .preferredFont(for: .title2, weight: .bold)
        tagWorkoutButton.layer.cornerRadius = .tagCornerRadius
        tagWorkoutButton.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMinYCorner,
            .layerMaxXMaxYCorner
        ]
        
        tagMeditationButton.center = view.center
        tagMeditationButton.layer.borderWidth = 3
        tagMeditationButton.layer.borderColor = UIColor.black.cgColor
        tagMeditationButton.setTitleColor(.black, for: .normal)
        tagMeditationButton.setTitle("Meditation", for: .normal)
        tagMeditationButton.titleLabel?.font = .preferredFont(for: .title2, weight: .bold)
        tagMeditationButton.layer.cornerRadius = .tagCornerRadius
        tagMeditationButton.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMinYCorner,
            .layerMaxXMaxYCorner
        ]
        
        tagNewTagButton.center = view.center
        tagNewTagButton.layer.borderWidth = 3
        tagNewTagButton.layer.borderColor = UIColor.black.cgColor
        tagNewTagButton.setTitleColor(.black, for: .normal)
        tagNewTagButton.setTitle("New Tag", for: .normal)
        tagNewTagButton.titleLabel?.font = .preferredFont(for: .title2, weight: .bold)
        tagNewTagButton.layer.cornerRadius = .tagCornerRadius
        
        
    }
    
    private func setupButtons(){
        self.ellipsisButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        self.tagWorkButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        self.tagStudyButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        self.tagFocusButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        self.tagWorkoutButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        self.tagMeditationButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        self.tagNewTagButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        let subviews = [
                        // Modal Identifier line
                        modalIdentifierLine,
                        
                        // Label
                        modalTagLabel,
                        
                        // Buttons
                        ellipsisButton,
                        tagWorkButton,
                        tagStudyButton,
                        tagFocusButton,
                        tagWorkoutButton,
                        tagMeditationButton,
                        tagNewTagButton
        ]
        
        subviews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Modal Identifier Line
            modalIdentifierLine.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            modalIdentifierLine.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            modalIdentifierLine.heightAnchor.constraint(equalToConstant: view.bounds.height * .modalIdentifierLineHeightCtt),
            modalIdentifierLine.widthAnchor.constraint(equalToConstant: view.bounds.width * .modalIdentifierLineWidthCtt),
            
            // Label
            modalTagLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            modalTagLabel.topAnchor.constraint(equalTo: modalIdentifierLine.bottomAnchor, constant: 12),
            
            // MARK: Buttons
            // Ellipsis
            ellipsisButton.leadingAnchor.constraint(equalTo: modalTagLabel.trailingAnchor, constant: 80),
            ellipsisButton.widthAnchor.constraint(equalToConstant: view.bounds.width * .ellipsisButtonWidthCtt),
            ellipsisButton.topAnchor.constraint(equalTo: modalIdentifierLine.bottomAnchor, constant: 12),
            ellipsisButton.heightAnchor.constraint(equalToConstant: view.bounds.height * .ellipsisButtonHeightCtt),
            
            // Work
            tagWorkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tagWorkButton.widthAnchor.constraint(equalToConstant: view.bounds.width * .tagWidthCtt),
            tagWorkButton.topAnchor.constraint(equalTo: modalTagLabel.bottomAnchor, constant: 28),
            tagWorkButton.heightAnchor.constraint(equalToConstant: view.bounds.height * .tagHeightCtt),
            
            // Study
            tagStudyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            tagStudyButton.widthAnchor.constraint(equalToConstant: view.bounds.width * .tagWidthCtt),
            tagStudyButton.topAnchor.constraint(equalTo: modalTagLabel.bottomAnchor, constant: 28),
            tagStudyButton.heightAnchor.constraint(equalToConstant: view.bounds.height * .tagHeightCtt),
            
            // Focus
            tagFocusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tagFocusButton.widthAnchor.constraint(equalToConstant: view.bounds.width * .tagWidthCtt),
            tagFocusButton.topAnchor.constraint(equalTo: tagWorkButton.bottomAnchor, constant: 12),
            tagFocusButton.heightAnchor.constraint(equalToConstant: view.bounds.height * .tagHeightCtt),
            
            // Workout
            tagWorkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            tagWorkoutButton.widthAnchor.constraint(equalToConstant: view.bounds.width * .tagWidthCtt),
            tagWorkoutButton.topAnchor.constraint(equalTo: tagStudyButton.bottomAnchor, constant: 12),
            tagWorkoutButton.heightAnchor.constraint(equalToConstant: view.bounds.height * .tagHeightCtt),
            
            // Meditation
            tagMeditationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tagMeditationButton.widthAnchor.constraint(equalToConstant: view.bounds.width * .tagWidthCtt),
            tagMeditationButton.topAnchor.constraint(equalTo: tagFocusButton.bottomAnchor, constant: 12),
            tagMeditationButton.heightAnchor.constraint(equalToConstant: view.bounds.height * .tagHeightCtt),
            
            // Workout
            tagNewTagButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            tagNewTagButton.widthAnchor.constraint(equalToConstant: view.bounds.width * .tagWidthCtt),
            tagNewTagButton.topAnchor.constraint(equalTo: tagWorkoutButton.bottomAnchor, constant: 12),
            tagNewTagButton.heightAnchor.constraint(equalToConstant: view.bounds.height * .tagHeightCtt),
            
            
        ])
    }
    
    @objc private func didTapButton(){
        print("Button Tapped")
    }
    
    
}

#Preview{
    SheetViewController()
}

extension Double {
    public static let modalIdentifierLineWidthCtt = 0.23
    public static let modalIdentifierLineHeightCtt = 0.01
    
    public static let ellipsisButtonWidthCtt = 0.07
    public static let ellipsisButtonHeightCtt = 0.03
}

extension CGFloat {
    public static let modalIdentifierLineCornerRadius = 5.00
    
    public static let tagCornerRadius = 15.00
    
    public static let tagWidthCtt = 0.36
    public static let tagHeightCtt = 0.06
}

extension UIFont {
    
    static func preferredFont(for style: TextStyle, weight: Weight, italic: Bool = false) -> UIFont {

        // Get the style's default pointSize
        let traits = UITraitCollection(preferredContentSizeCategory: .large)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style, compatibleWith: traits)

        // Get the font at the default size and preferred weight
        var font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        if italic == true {
            font = font.with([.traitItalic])
        }

        // Setup the font to be auto-scalable
        let metrics = UIFontMetrics(forTextStyle: style)
        return metrics.scaledFont(for: font)
    }
    
    private func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
