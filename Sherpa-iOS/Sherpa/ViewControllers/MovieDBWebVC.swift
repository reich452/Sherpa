//
//  MovieDBWebVC.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/11/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit
import WebKit

class MovieDBWebVC: UIViewController, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!

    let progressView = UIProgressView(progressViewStyle: .default)
    private var estimatedProgressObserver: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        setupProgressView()
        setupEstimatedProgressObserver()
        
        if let initialUrl = URL(string: "https://www.themoviedb.org") {
            setupWebview(url: initialUrl)
        }
    }
    
    private func setupProgressView() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        progressView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(progressView)
        progressView.isHidden = true
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
            
            progressView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2.0)
            ])
    }

    
    private func setupEstimatedProgressObserver() {
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    private func setupWebview(url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - Delegate 
    
    func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
        if progressView.isHidden {
            progressView.isHidden = false
        }
        UIView.animate(withDuration: 0.33,
                       animations: {
                        self.progressView.alpha = 1.0
        })
    }
    
    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        UIView.animate(withDuration: 0.33,
                       animations: {
                        self.progressView.alpha = 0.0
        },
                       completion: { isFinished in
                        self.progressView.isHidden = isFinished
        })
    }
}
