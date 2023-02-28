//
//  OverlayVC.swift
//  Sherpa
//
//  Created by Nick Reichard on 4/9/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

protocol OverlayVCDelegate: AnyObject {
    func dismissedVC()
}

class OverlayVC: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var cardView: CardView!
    @IBOutlet private weak var checkBtn: UIButton!
    @IBOutlet private weak var timeLabel: UILabel!
    
    // MARK: - Properties
    public var uploadTime: Double = 0.0
    public var message = ""
    weak var delegate: OverlayVCDelegate?
  
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        if message.isEmpty {
            timeLabel.text = "\(uploadTime.formattedTime)"
        } else {
            titleLabel.text = "Report Sent"
            timeLabel.text = message
            timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        }
    }
    
    // MARK: - Actions
    @IBAction private func okButtonTapped(_ sender: CustomButton) {

        dismiss(animated: true) {
            guard let delegate = self.delegate else { return }
            delegate.dismissedVC()
        }
    }
}
