//
//  InsightsViewModel.swift
//  MAcro02-Grupo02
//
//  Created by Luiz Felipe on 30/09/24.
//

import Foundation
import UIKit
import SwiftUI

protocol InsightsViewProtocol: AnyObject {
    
}

class InsightsViewController: UIViewController {
    var interactor:InsightsInteractorProtocol?
    
    private let bgRectangleTop = UIView();
    private let fgRectangleTop = UIView();
    private let bgPauseRectangle = UIView();
    private let bgTotalRectangle = UIView();
    private let insightsSwiftUIView = UIView();

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        setupFocusStats()
        setupConstraints()
//        setupSwiftUIView()
    }
    
    func setupSwiftUIView(){
        // Create an instance of SwiftUIViewController
        let insightsSwiftUIViewController = InsightsSwiftUIViewController()
        
        // Set the frame and add the SwiftUI view
        insightsSwiftUIViewController.view.frame = view.bounds
        insightsSwiftUIView.addSubview(insightsSwiftUIViewController.view)
        
        // Notify the child view controller that it's being added
        insightsSwiftUIViewController.didMove(toParent: self)
    }
    
    func setupFocusStats(){
        //Top Rectangle Stats
        bgRectangleTop.center = view.center
        bgRectangleTop.backgroundColor = .systemGray3
        bgRectangleTop.layer.cornerRadius = 15
        
        fgRectangleTop.center = view.center
        fgRectangleTop.backgroundColor = .systemGray
        fgRectangleTop.layer.cornerRadius = 15
        
        // Center Rectangles
        bgPauseRectangle.center = view.center
        bgPauseRectangle.backgroundColor = .systemGray3
        bgPauseRectangle.layer.cornerRadius = 15
        
        bgTotalRectangle.center = view.center
        bgTotalRectangle.backgroundColor = .systemGray3
        bgTotalRectangle.layer.cornerRadius = 15
        
        // Insights SwiftUI View
        insightsSwiftUIView.center = view.center
        insightsSwiftUIView.backgroundColor = .red
    }
    
    private func setupConstraints() {
        let subviews = [bgRectangleTop, fgRectangleTop, bgPauseRectangle, bgTotalRectangle, insightsSwiftUIView]
        subviews.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Background Top Rectangle Constraints
            bgRectangleTop.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            bgRectangleTop.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            bgRectangleTop.heightAnchor.constraint(equalToConstant: view.bounds.height * .bgRectangleTopHeightCtt),
            
            bgRectangleTop.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bgRectangleTop.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Foreground Top Rectangle Constraints
            fgRectangleTop.topAnchor.constraint(equalTo: bgRectangleTop.topAnchor, constant: 8),
            fgRectangleTop.bottomAnchor.constraint(equalTo: bgRectangleTop.bottomAnchor, constant: -8),
            
            fgRectangleTop.trailingAnchor.constraint(equalTo: bgRectangleTop.trailingAnchor, constant: -8),
            fgRectangleTop.widthAnchor.constraint(equalTo: fgRectangleTop.heightAnchor),
            
            // Background Pause And Total Rectangles
            bgPauseRectangle.topAnchor.constraint(equalTo: bgRectangleTop.bottomAnchor, constant: 20),
            bgPauseRectangle.heightAnchor.constraint(equalToConstant: view.bounds.height * .bgPauseAndTotalRectanglesHeightCtt),
            
            bgPauseRectangle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bgPauseRectangle.widthAnchor.constraint(equalToConstant: view.bounds.width * .bgPauseAndTotalRectanglesWidthCtt - 25),
            
            bgTotalRectangle.topAnchor.constraint(equalTo: bgRectangleTop.bottomAnchor, constant: 20),
            bgTotalRectangle.heightAnchor.constraint(equalToConstant: view.bounds.height * .bgPauseAndTotalRectanglesHeightCtt),
            
            bgTotalRectangle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bgTotalRectangle.widthAnchor.constraint(equalToConstant: view.bounds.width * .bgPauseAndTotalRectanglesWidthCtt - 25),
            
            // Insights SwiftUI View
            insightsSwiftUIView.topAnchor.constraint(equalTo: bgPauseRectangle.bottomAnchor),
            insightsSwiftUIView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            insightsSwiftUIView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            insightsSwiftUIView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            ])
    }
    
}

extension InsightsViewController: InsightsViewProtocol{
    
    
    
}

#Preview {
    InsightsViewController().showLivePreview()
}


extension Double {
//    public static let bgRectangleTopHeightCtt = 0.15
//    public static let bgPauseAndTotalRectanglesHeightCtt = 0.08
//    public static let bgPauseAndTotalRectanglesWidthCtt = 0.5
}
