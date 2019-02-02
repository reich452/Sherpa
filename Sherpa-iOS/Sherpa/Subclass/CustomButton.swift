//
//  CustomButton.swift
//  Sherpa
//
//  Created by Nick Reichard on 1/11/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable var isRighImageAligned: Bool = false
    @IBInspectable var isGradientBgOn: Bool = false
    @IBInspectable var topGradiant: UIColor = UIColor.black
    @IBInspectable var bottomGradiant: UIColor = UIColor.white
    
    @IBInspectable var titleLeftPadding: Double = 0.0 {
        didSet {
            titleEdgeInsets.left = CGFloat(titleLeftPadding)
        }
    }
    
    @IBInspectable var titleRightPadding: Double = 0.0 {
        didSet {
            titleEdgeInsets.right = CGFloat(titleRightPadding)
        }
    }
    
    @IBInspectable var titleTopPadding: Double = 0.0 {
        didSet {
            titleEdgeInsets.top = CGFloat(titleTopPadding)
        }
    }
    
    @IBInspectable var titleBottomPadding: Double = 0.0 {
        didSet {
            titleEdgeInsets.bottom = CGFloat(titleBottomPadding)
        }
    }
    
    @IBInspectable var imageLeftPadding: Double = 0.0 {
        didSet {
            if !isRighImageAligned {
                imageEdgeInsets.left = CGFloat(imageLeftPadding)
            }
        }
    }
    
    @IBInspectable var imageRightPadding: Double = 0.0 {
        didSet {
            imageEdgeInsets.right = CGFloat(imageRightPadding)
        }
    }
    
    @IBInspectable var imageTopPadding: Double = 0.0 {
        didSet {
            imageEdgeInsets.top = CGFloat(imageTopPadding)
        }
    }
    
    @IBInspectable var imageBottomPadding: Double = 0.0 {
        didSet {
            imageEdgeInsets.bottom = CGFloat(imageBottomPadding)
        }
    }
    
    @IBInspectable var cornerRadius: Double = 0.0 {
        didSet {
            layer.cornerRadius = CGFloat(cornerRadius)
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: Double = 0.0 {
        didSet {
            layer.borderWidth = CGFloat(borderWidth)
        }
    }
    
    @IBInspectable var borderColor: UIColor = .black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isRighImageAligned,
            let imageView = imageView {
            imageEdgeInsets.left = self.bounds.width - imageView.bounds.size.width - CGFloat(imageLeftPadding)
        }
        
        if isGradientBgOn {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [topGradiant.cgColor, bottomGradiant.cgColor]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}

