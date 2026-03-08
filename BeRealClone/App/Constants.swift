//
//  Constants.swift
//  BeRealClone
//
//  Created by David Castaneda on 3/3/26.
//

import Foundation

enum Constants {
    static let storyboardName = "Main"

    // Storyboard IDs (we’ll set these later in Main.storyboard)
    static let loginNavigationControllerIdentifier = "LoginNavigationController"
    static let mainNavigationControllerIdentifier  = "MainNavigationController"

    enum Notifications {
        static let login  = Notification.Name("login")
        static let logout = Notification.Name("logout")
    }

    enum Parse {
        // Put your Back4App keys here later
        static let applicationId = "Mt3epiAdlGDv8d2nozIWFzpnXgYh0YImlIUpkMJm"
        static let clientKey     = "XSiJovFOjP1emZw3QRKKJcCHL99NLQLbQhGDbmpJ"
        static let serverURL     = URL(string: "https://parseapi.back4app.com/parse")!
    }
}
