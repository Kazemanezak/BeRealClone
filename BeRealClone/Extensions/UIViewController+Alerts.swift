//
//  UIViewController+Alerts.swift
//  BeRealClone
//
//  Created by David Castaneda on 3/3/26.
//

import UIKit

extension UIViewController {
    func showAlert(title: String = "Error", description: String = "Something went wrong.") {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
