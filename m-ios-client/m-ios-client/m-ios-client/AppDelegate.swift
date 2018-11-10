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

    let tabBarController = UITabBarController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        window?.tintColor = UIColor.ray_orange

        let mapVC = MapViewController(mapObjects: nil)
        let mapNC = UINavigationController(rootViewController: mapVC)
        mapNC.tabBarItem = UITabBarItem(title: NSLocalizedString("map tab", comment: ""),
                                        image: UIImage(named: "map-tab")?.withRenderingMode(.alwaysOriginal),
                                        selectedImage: UIImage(named: "map-tab-selected")?.withRenderingMode(.alwaysOriginal))

        let filterVC = FilterViewController(venueTags: Set(), venueTagsCheked: Set(), taskTags: Set(["tag1", "tag2"]), taskTagsCheked: Set(), style: .search)
        let filterNC = UINavigationController(rootViewController: filterVC)
        filterNC.tabBarItem = UITabBarItem(title: NSLocalizedString("tasks tab", comment: ""),
                                           image: UIImage(named: "tasks-tab")?.withRenderingMode(.alwaysOriginal),
                                           selectedImage: UIImage(named: "tasks-tab-selected")?.withRenderingMode(.alwaysOriginal))

        let myQuestsVC = QuestsSearchViewController()
        let myQuestsNC = UINavigationController(rootViewController: myQuestsVC)
        myQuestsNC.tabBarItem = UITabBarItem(title: NSLocalizedString("my quests tab", comment: ""),
                                             image: UIImage(named: "user-tab")?.withRenderingMode(.alwaysOriginal),
                                             selectedImage: UIImage(named: "user-tab-selected")?.withRenderingMode(.alwaysOriginal))

        tabBarController.viewControllers = [mapNC, filterNC, myQuestsNC]

        return true
    }

    func navigateToMyQuests() {
        tabBarController.viewControllers?.forEach({ vc in
            if let nc = vc as? UINavigationController {
                nc.popToRootViewController(animated: false)
            }
        })
        tabBarController.selectedViewController = tabBarController.viewControllers?[2]
        DispatchQueue.main.async {
            let nc = (self.tabBarController.selectedViewController as? UINavigationController)
            nc?.setViewControllers([QuestsSearchViewController()], animated: true)
        }
    }
}
