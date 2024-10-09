//
//  PreviewExtension.swift
//  MAcro02-Grupo02
//
//  Created by Letícia Malagutti on 07/10/24.
//
// Código para extension que permite que as views tenham live preview como no swiftui

import SwiftUI

extension UIViewController {
    
    private struct ControllerPreview: UIViewControllerRepresentable {
        let viewcontroller: UIViewController
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewcontroller
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        
    }
    
    func showLivePreview() -> some View {
        ControllerPreview(viewcontroller: self)
    }
    
}

extension UIView {
    private struct ViewPreview: UIViewRepresentable {
        typealias UIViewType = UIView
        let view: UIView
        func makeUIView(context: Context) -> UIView {
            return view
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {
            
        }
    }
    
    func showLivePreview() -> some View {
        ViewPreview(view: self)
    }
}
