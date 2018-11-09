//
//  AppDelegate.swift
//  m-ios-client
//
//  Created by Denis Morozov on 09.11.2018.
//  Copyright © 2018 Denis Morozov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = UITabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        let mapVC = MapViewController()
        mapVC.tabBarItem = UITabBarItem(title: "Map", image: nil, selectedImage: nil)
        tabBarController.viewControllers = [mapVC]

        return true
    }
}
