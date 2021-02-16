//
//  UIViewControllerExtension.swift
//  Bricket
//
//  Created by Константин Киски on 15.11.2020.
//

import Foundation
import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func setEnableButton(button: UIButton) {
        button.isEnabled = true
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.00, green: 0.48, blue: 1.00, alpha: 1.00)
    }
    
    func setDisableButton(button: UIButton) {
        button.isEnabled = false
        button.setTitleColor(UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 0.60), for: .normal)
        button.backgroundColor = UIColor(red: 0.46, green: 0.46, blue: 0.50, alpha: 0.12)
    }
    
}
