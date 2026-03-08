//
//  AppDelegate.swift
//  BeRealClone
//
//  Created by David Castaneda on 3/3/26.
//

import UIKit
import ParseSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        ParseSwift.initialize(
            applicationId: Constants.Parse.applicationId,
            clientKey: Constants.Parse.clientKey,
            serverURL: Constants.Parse.serverURL
        )

        return true
    }
}
