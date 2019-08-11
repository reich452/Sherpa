//
//  ScondOnboardVC.swift
//  Sherpa
//
//  Created by Nick Reichard on 8/5/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

class SecondOnboardVC: UIViewController {
   
    @IBOutlet weak var dbImageView: UIImageView!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbImageView.clipsToBounds = true
        dbImageView.layer.cornerRadius = 12
        view.backgroundColor = .primaryColor
    }
    @IBAction func handelTapGestures(_ sender: UITapGestureRecognizer) {
        
        performAnimation()
    }
    
    private func performAnimation() {
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
            let parentVC = self.parent as? OnboardingPageVC
            parentVC?.pageIndex = 2
            parentVC?.goToNextPage()
        }
    }
}
