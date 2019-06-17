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
        let firstNavigationController = UINavigationController(rootViewController: navigationController)
        firstNavigationController.title = "Home"
        firstNavigationController.tabBarItem.image = #imageLiteral(resourceName: "xcHome_Icon")
        
        let storyboard2 = UIStoryboard(name: Constants.dbActionTab, bundle: nil)
        let decadeSearchTVC = storyboard2.instantiateViewController(withIdentifier: Constants.dataBaseActionTVC)
        let secondNavigationController = UINavigationController(rootViewController: decadeSearchTVC)
        secondNavigationController.title = "CloudKit"
        secondNavigationController.tabBarItem.image = #imageLiteral(resourceName: "xcCloudKit_Icon")
        
        let storyboard3 = UIStoryboard(name: Constants.dbActionTab, bundle: nil)
        let saveSearchTVC = storyboard3.instantiateViewController(withIdentifier: Constants.dataBaseActionTVC)
        let thridNavigationController = UINavigationController(rootViewController: saveSearchTVC)
        thridNavigationController.title = "Firebase"
        thridNavigationController.tabBarItem.image = #imageLiteral(resourceName: "xcFirebase_Icon")

        viewControllers = [firstNavigationController, secondNavigationController, thridNavigationController]
        tabBar.isTranslucent = true
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        
        // MARK: TODO - Solidify Theme 
        topBorder.backgroundColor = UIColor.darkGray.cgColor
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
        
    }

}
