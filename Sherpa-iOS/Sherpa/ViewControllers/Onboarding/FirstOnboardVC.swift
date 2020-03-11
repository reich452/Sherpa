//
//  FirstOnboardVC.swift
//  Sherpa
//
//  Created by Nick Reichard on 8/5/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

class FirstOnboardVC: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryColor
    }
    
    @IBAction func handelTapGestures(_ sender: UITapGestureRecognizer) {
        performAnimation()
    }
    
    private func performAnimation() {
        let sequence = AnimationSequence(withStepDuration: 0.5)
        sequence.doStep {
            self.titleLabel.transform = CGAffineTransform(translationX: -30, y: 0)
        }
        sequence.doStep {
            self.titleLabel.alpha = 0
            self.titleLabel.transform = CGAffineTransform(translationX: -30, y: -200)
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
            parentVC?.pageIndex = 1
            parentVC?.goToNextPage()
        }
    }
}
