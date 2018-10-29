//
//  PublicProtocols.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit
public protocol ActivityIndicatorPresenter {
    
    var activityIndicator: UIActivityIndicatorView { get }

    func showActivityIndicator()
    
    func hideActivityIndicator()
}

public extension ActivityIndicatorPresenter where Self: UIViewController {
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            
            self.activityIndicator.style = .whiteLarge
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80) //or whatever size you would like
            self.activityIndicator.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.height / 2)
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
}
