//
//  SherpaTextField.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit
@IBDesignable
class SherpaTextField: UITextField {
    
    let border = CALayer()
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    @IBInspectable var bottomBorderColor: UIColor? {
        didSet {
            setup()
        }
    }
    
    @IBInspectable var bottomBorderWidth: CGFloat = 0.5 {
        didSet {
            setup()
        }
    }
    
    func updateTextField() {
        
        if borderStyle == UITextField.BorderStyle.none || borderStyle == UITextField.BorderStyle.line {
            self.layer.borderColor = UIColor.offsetBlack.cgColor
        }
    }
    
    func setup() {
        border.borderColor = self.borderColor?.cgColor
        
        border.borderWidth = borderWidth
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
    
    // MARK: - Overrides 
    
    override func layoutSubviews() {
        super.layoutSubviews()
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: frame.size.width, height: self.frame.size.height)
    }
    
    override var tintColor: UIColor? {
        
        didSet {
            setNeedsDisplay()
        }
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func draw(_ rect: CGRect) {
        
        let startingPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let endingPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        
        let path = UIBezierPath()
        path.move(to: startingPoint)
        path.addLine(to: endingPoint)
        path.lineWidth = 1
        tintColor?.setStroke()
        path.stroke()
    }
}
