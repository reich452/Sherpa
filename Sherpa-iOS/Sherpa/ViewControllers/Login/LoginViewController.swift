//
//  LoginViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 1/11/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

extension UIColor {
    static let lightBluee = UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    static let darkBlue = UIColor(red: 18.0/255.0, green: 10.0/255.0, blue: 243.0/255.0, alpha: 1.0)
}

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addVerticalGradientLayer(topColor: .lightBluee, bottomColor: .darkBlue)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
