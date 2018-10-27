//
//  MainTabBarViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/27/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        customTabBar()
        self.tabBar.barTintColor = UIColor.black
    }
    
    func customTabBar() {
        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard1.instantiateViewController(withIdentifier: "HomeViewController")
        navigationController.title = "Home"
        navigationController.tabBarItem.image = #imageLiteral(resourceName: "xcHome_Icon")
        
        let storyboard2 = UIStoryboard(name: Constants.cloudKitTab, bundle: nil)
        let decadeSearchTVC = storyboard2.instantiateViewController(withIdentifier: Constants.cloudKitTVC)
        let secondNavigationController = UINavigationController(rootViewController: decadeSearchTVC)
        secondNavigationController.title = "CloudKit"
        secondNavigationController.tabBarItem.image = #imageLiteral(resourceName: "xcCloudKit_Icon")
        
        let storyboard3 = UIStoryboard(name: Constants.firebaseTab, bundle: nil)
        let saveSearchTVC = storyboard3.instantiateViewController(withIdentifier: Constants.firebaseTVC)
        let thridNavigationController = UINavigationController(rootViewController: saveSearchTVC)
        thridNavigationController.title = "Firebase"
        thridNavigationController.tabBarItem.image = #imageLiteral(resourceName: "xcFirebase_Icon")

        
        viewControllers = [navigationController, secondNavigationController, thridNavigationController]
        tabBar.isTranslucent = true
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        
        // MARK: TODO - Solidify Theme 
        topBorder.backgroundColor = UIColor.blue.cgColor
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
        
    }

}
