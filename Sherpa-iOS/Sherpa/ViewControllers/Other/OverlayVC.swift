//
//  OverlayVC.swift
//  Sherpa
//
//  Created by Nick Reichard on 4/9/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

protocol OverlayVCDelegate: class {
    func dismissedVC()
}

class OverlayVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - Properties
    var uploadTime: Double = 0.0
    weak var delegate: OverlayVCDelegate?
  
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        timeLabel.text = "\(uploadTime.formattedTime)"
    }
    
    // MARK: - Actions
    @IBAction func okButtonTapped(_ sender: CustomButton) {

        dismiss(animated: true) {
            guard let delegate = self.delegate else { return }
            delegate.dismissedVC()
        }
    }
    
}
