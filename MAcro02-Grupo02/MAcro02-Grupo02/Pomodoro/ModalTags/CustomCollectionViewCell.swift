//
//  CustomCollectionViewCell.swift
//  MAcro02-Grupo02
//
//  Created by Letícia Malagutti on 30/10/24.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomCollectionViewCell"
    
    let myTagsView: UIButton = {
        let iv = UIButton(type: .system)
        iv.setTitle("My Title", for: .normal)
        iv.contentMode = .scaleAspectFill
        iv.tintColor = AppColors.backgroundPrimary
        iv.clipsToBounds = true
        iv.addTarget(CustomCollectionViewCell.self, action: #selector(didTapButtonCV), for: .touchUpInside)
        return iv
    }()
    
    let removeButton: UIButton = {
        let iv = UIButton(type: .system)
        iv.setBackgroundImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        iv.tintColor = .red
        return iv
    }()
    
    public func configure(with myTitle: String) {
        self.myTagsView.setTitle(myTitle, for: .normal)
        self.setupUI()
    }
    
    @objc func didTapButtonCV(){
        print("Button inside CollectionView tapped")
    }
    
    private func setupUI() {
        myTagsView.center = self.center
        myTagsView.layer.borderWidth = 3
        myTagsView.layer.borderColor = UIColor.black.cgColor
        myTagsView.setTitleColor(.black, for: .normal)
        myTagsView.titleLabel?.font = .preferredFont(for: .title2, weight: .bold)
        myTagsView.layer.cornerRadius = .tagCornerRadius
        myTagsView.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMinYCorner,
            .layerMaxXMaxYCorner
        ]
        
        
        myTagsView.backgroundColor = .systemBlue
        self.backgroundColor = AppColors.backgroundPrimary
        
        // Adjusting title label size to fit button width with padding
        myTagsView.titleLabel?.adjustsFontSizeToFitWidth = true
        myTagsView.titleLabel?.minimumScaleFactor = 0.3
        myTagsView.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        self.addSubview(myTagsView)
        myTagsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myTagsView.widthAnchor.constraint(equalToConstant: self.contentView.bounds.width),
            myTagsView.heightAnchor.constraint(equalToConstant: self.contentView.bounds.width * .tagHeightCttModal),
            
//            removeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.myTagsView.setTitle(nil, for: .normal)
    }
    
}
#Preview {
    SheetViewController()
}
