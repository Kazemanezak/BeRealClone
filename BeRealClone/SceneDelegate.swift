//
//  SceneDelegate.swift
//  BeRealClone
//
//  Created by David Castaneda on 3/3/26.
//

import UIKit
import ParseSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(login),
                                               name: Constants.Notifications.login,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(logout),
                                               name: Constants.Notifications.logout,
                                               object: nil)

        // Start on Login by default (until Parse keys are real)
        showLogin()

        window?.makeKeyAndVisible()
    }

    private func showLogin() {
        let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: Constants.loginNavigationControllerIdentifier)
        window?.rootViewController = vc
    }

    @objc private func login() {
        let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: Constants.mainNavigationControllerIdentifier)
        window?.rootViewController = vc
    }

    @objc private func logout() {
        User.logout { [weak self] _ in
            DispatchQueue.main.async {
                self?.showLogin()
            }
        }
    }
}
