//
//  UIKITTextField.swift
//  MAcro02-Grupo02
//
//  Created by Letícia Malagutti on 01/11/24.
//
import UIKit

class UIKITTextField: UITextField, UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
