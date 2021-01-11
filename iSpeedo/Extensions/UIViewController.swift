//
//  UIViewController.swift
//  iSpeedo
//
//  Created by admin on 11/01/21.
//

import UIKit


extension UIViewController {
    func showAlert(title: String, message: String, okTitle: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okTitle,
                                      style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
