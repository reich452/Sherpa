//
//  MovieOverlayView.swift
//  Sherpa
//
//  Created by Nick Reichard on 4/9/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit
import Koloda

class MovieOverlayView: OverlayView {

    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
    
        var imageView = UIImageView(frame: self.bounds)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.layer.opacity = 0.7
        self.addSubview(imageView)
        return imageView
        }()
    
    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left? :
                overlayImageView.image = #imageLiteral(resourceName: "xcePoopEmoji")
            case .right? :
                overlayImageView.image = #imageLiteral(resourceName: "xceHappyFace")
            default:
                overlayImageView.image = nil
            }
        }
    }
}
