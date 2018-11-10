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

        let mapVC = MapViewController(mapObjects: nil)
        let mapNC = UINavigationController(rootViewController: mapVC)
        mapNC.tabBarItem = UITabBarItem(title: NSLocalizedString("map tab", comment: ""),
                                        image: nil, selectedImage: nil)

        let filterVC = FilterViewController(venueTags: Set(), venueTagsCheked: Set(), taskTags: Set(["tag1", "tag2"]), taskTagsCheked: Set(), style: .search)
        let filterNC = UINavigationController(rootViewController: filterVC)
        filterNC.tabBarItem = UITabBarItem(title: NSLocalizedString("filter tab", comment: ""),
                                           image: nil, selectedImage: nil)

        tabBarController.viewControllers = [mapNC, filterNC]

        return true
    }
}
