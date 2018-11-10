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

        let mapVC = MapViewController(mapObjects: nil)
        let mapNC = UINavigationController(rootViewController: mapVC)
        mapNC.tabBarItem = UITabBarItem(title: NSLocalizedString("map tab", comment: ""),
                                        image: nil, selectedImage: nil)

        let filterVC = FilterViewController(venueTags: Set(), venueTagsCheked: Set(), taskTags: Set(["tag1", "tag2"]), taskTagsCheked: Set(), style: .search)
        let filterNC = UINavigationController(rootViewController: filterVC)
        filterNC.tabBarItem = UITabBarItem(title: NSLocalizedString("filter tab", comment: ""),
                                           image: nil, selectedImage: nil)

        let myQuestsVC = QuestsSearchViewController()
        let myQuestsNC = UINavigationController(rootViewController: myQuestsVC)
        myQuestsNC.tabBarItem = UITabBarItem(title: NSLocalizedString("my quests tab", comment: ""),
                                            image: nil, selectedImage: nil)

        tabBarController.viewControllers = [mapNC, filterNC, myQuestsNC]

        return true
    }

    func navigateToInprogressOrder(record: Sh_Generated_ShelterQuestRecord) {
        tabBarController.viewControllers?.forEach({ vc in
            if let nc = vc as? UINavigationController {
                nc.popToRootViewController(animated: false)
            }
        })
        tabBarController.selectedViewController = tabBarController.viewControllers?[2]
        let viewControllers: [UIViewController] = [QuestsSearchViewController()]
        // add list quests
//        viewControllers.append(QuestDetailsViewController(quest: record.shelterQuest, record: record))
        (tabBarController.selectedViewController as? UINavigationController)?.setViewControllers(viewControllers, animated: true)
    }
}
