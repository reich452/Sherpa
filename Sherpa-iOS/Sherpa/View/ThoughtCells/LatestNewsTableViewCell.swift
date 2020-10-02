//
//  ReadOrWriteTableViewCell.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/21/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit
import WebKit

protocol LatestNewsTableViewCellDelegate: class {
    func didTapPlayButton(_ cell: LatestNewsTableViewCell)
}

class LatestNewsTableViewCell: UITableViewCell, WKNavigationDelegate {
    
    @IBOutlet private weak var headerTitleLabel: UILabel!
    @IBOutlet private weak var headerImage: UIImageView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var playViewBackground: UIView!
    @IBOutlet private weak var overlayPlayBtn: UIButton!
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var percentLabel: UILabel!
    
    private var estimatedProgressObserver: NSKeyValueObservation?
    weak var delegate: LatestNewsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        contentView.backgroundColor = .primaryColor
        playViewBackground.makeRoundView()
        headerImage.roundCornersForAspectFit(radius: 8)
        webView.navigationDelegate = self
    }
    
    // MARK: - Actions

    @IBAction private func playBtnTapped(_ sender: Any) {
        delegate?.didTapPlayButton(self)
    }
    
    func updateViews(selectedDB: SelectedIconDB) {
    
        if selectedDB == .cloudKit {
            webView.isHidden = true
            headerTitleLabel.text = "Check out the latest from WWDC. Using CoreData with CloudKit."
            percentLabel.isHidden = true
        } else {
            webView.isHidden = false
            percentLabel.isHidden = false
            webView.alpha = 0
            headerImage.image = #imageLiteral(resourceName: "xcFirebase_logo")
            setupEstimatedProgressObserver()
            let url = URL(string: "https://www.youtube.com/embed/iMkifTEaefE")!
            webView.load(URLRequest(url: url))
            headerTitleLabel.text = "Check out what's new with Firebase!"
        }
    }

    
    private func setupEstimatedProgressObserver() {
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.percentLabel.text = "\(webView.estimatedProgress.rounded(.toNearestOrAwayFromZero))0%".replacingOccurrences(of: ".", with: "")
        }
    }
    // MARK: - Delegate
    
    func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        if percentLabel.isHidden {
            percentLabel.isHidden = false
        }
        UIView.animate(withDuration: 0.33,
                       animations: {
                        self.percentLabel.alpha = 1.0
        })
    }
    
    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        UIView.animate(withDuration: 0.33,
                       animations: {
                        self.percentLabel.alpha = 0.0
                        self.webView.alpha = 1.0
        },
                       completion: { isFinished in
                        self.percentLabel.isHidden = isFinished
        })
    }
}
