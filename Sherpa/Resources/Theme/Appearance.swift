//
//  Appearance.swift
//  Sherpa
//
//  Created by Nick Reichard on 8/10/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit
enum Appearance {
    
    static func configure() {
        
        UINavigationBar.appearance().prefersLargeTitles = true
        
        UINavigationBar.appearance().backgroundColor = .primaryColor
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .primaryColor
        UINavigationBar.appearance().barStyle = .black
        // Navigation bar title text
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.appWhite
        ]
        UILabel.appearance().textColor = .appWhite
    }
}
