//
//  AppDelegate.swift
//  FrogogoTestApp
//
//  Created by Narek Stepanyan on 13/09/2019.
//  Copyright © 2019 Narek Stepanyan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let usersListController = UsersListViewController()
        let navController = UINavigationController(rootViewController: usersListController)
        navController.navigationBar.prefersLargeTitles = true
        usersListController.title = "Title"
        window!.rootViewController = navController
        window!.makeKeyAndVisible()
        return true
    }
}
