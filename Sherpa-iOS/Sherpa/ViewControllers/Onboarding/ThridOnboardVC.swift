//
//  ThridOnboardVC.swift
//  Sherpa
//
//  Created by Nick Reichard on 8/5/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

class ThirdOnboardVC: UIViewController {
    
    // MARK: - IBOutlets 
    
    @IBOutlet private weak var dbImageView: UIImageView!
    @IBOutlet private weak var bodyLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbImageView.clipsToBounds = true
        dbImageView.layer.cornerRadius = 12
        view.backgroundColor = .primaryColor
    }
    
    // MARK: - Actions
    
    @IBAction func handelTapGestures(_ sender: UITapGestureRecognizer) {
        performAnimation()
    }
}

// MARK - Private

private extension ThirdOnboardVC {
    
    func performAnimation() {
        let sequence = AnimationSequence(withStepDuration: 0.5)
        sequence.doStep {
            self.dbImageView.transform = CGAffineTransform(translationX: -30, y: 0)
        }
        sequence.doStep {
            self.dbImageView.alpha = 0
            self.dbImageView.transform = CGAffineTransform(translationX: -30, y: -200)
        }
        sequence.execute()
        
        let secondSq = AnimationSequence(withStepDuration: 0.6)
        secondSq.doStep {
            self.bodyLabel.transform = CGAffineTransform(translationX: -30, y: 0)
        }
        secondSq.doStep {
            self.bodyLabel.alpha = 0
            self.bodyLabel.transform = CGAffineTransform(translationX: -30, y: -200)
        }
        secondSq.execute()
        secondSq.onCompletion {
            self.goToMainTab()
        }
    }
    
    func goToMainTab() {
        let mainVC = MainTabBarViewController.instantiate(fromAppStoryboard: .MainTabBar)
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }

        window?.switchRootViewController(mainVC, animated: true) {
//            UserDefaults.standard.set(true, forKey: Constants.hasSeenOnboarding)
        }
    }
}
