//
//  SignUpViewController.swift
//  BeRealClone
//
//  Created by David Castaneda on 3/3/26.
//

import UIKit
import ParseSwift

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func onSignUpTapped(_ sender: UIButton) {
        guard
            let username = usernameTextField.text, !username.isEmpty,
            let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
        else {
            showAlert(description: "Fill in username, email, and password.")
            return
        }

        var newUser = User()
        newUser.username = username
        newUser.email = email
        newUser.password = password

        newUser.signup { [weak self] result in
            switch result {
            case .success:
                NotificationCenter.default.post(name: Constants.Notifications.login, object: nil)
            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
        }
    }
}
