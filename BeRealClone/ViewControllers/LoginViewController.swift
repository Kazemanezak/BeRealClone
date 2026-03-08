//
//  LoginViewController.swift
//  BeRealClone
//
//  Created by David Castaneda on 3/3/26.
//

import UIKit
import ParseSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func onLoginTapped(_ sender: UIButton) {
        guard
            let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
        else {
            showAlert(description: "Enter username and password.")
            return
        }

        User.login(username: username, password: password) { [weak self] result in
            switch result {
            case .success:
                NotificationCenter.default.post(name: Constants.Notifications.login, object: nil)
            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
        }
    }
}
