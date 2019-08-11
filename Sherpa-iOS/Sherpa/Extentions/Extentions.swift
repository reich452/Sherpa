//
//  Extentions.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/27/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

// MARK: - UIViewController

extension UIViewController {
    func showAlertMessage(titleStr:String, messageStr:String, actionString: String? = nil, style: UIAlertAction.Style? = nil, completion: @escaping (UIAlertAction?) -> Void) {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
        let settingsAction = UIAlertAction(title: actionString, style: style ?? .default, handler: completion)
        alert.addAction(settingsAction)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNoActionAlert(titleStr:String, messageStr:String, style: UIAlertAction.Style) {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
    
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    
}

// MARK: - UIView

extension UIView {
    
    func makeRoundView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
    }
    
    func addVerticalGradientLayer(topColor: UIColor, bottomColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [
            topColor.cgColor,
            bottomColor.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension UIImageView {
    func roundCornersForAspectFit(radius: CGFloat) {
        if let image = self.image {
            //calculate drawingRect
            let boundsScale = self.bounds.size.width / self.bounds.size.height
            let imageScale = image.size.width / image.size.height
            
            var drawingRect: CGRect = self.bounds
            
            if boundsScale > imageScale {
                drawingRect.size.width =  drawingRect.size.height * imageScale
                drawingRect.origin.x = (self.bounds.size.width - drawingRect.size.width) / 2
            } else {
                drawingRect.size.height = drawingRect.size.width / imageScale
                drawingRect.origin.y = (self.bounds.size.height - drawingRect.size.height) / 2
            }
            let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}

// MARK: - TextField

extension UITextField {
    
    func setBottomBorder(withColor color: UIColor) {
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        let width: CGFloat = 1.0
        
        let borderLine = UIView(frame: CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width))
        borderLine.backgroundColor = color
        self.addSubview(borderLine)
    }
}

extension UITextView {
    
    func addAccessoryView(_ text: String) {
        let accessory: UIView = {
            let accessoryView = UIView(frame: .zero)
            accessoryView.backgroundColor = UIColor.groupTableViewBackground
            return accessoryView
        }()
        let cancelButton: UIButton = {
            let cancelButton = UIButton(type: .custom)
            cancelButton.setTitle("Done", for: .normal)
            cancelButton.setTitleColor(#colorLiteral(red: 0.1607843137, green: 0.368627451, blue: 0.5803921569, alpha: 1), for: .normal)
            cancelButton.addTarget(self, action:
                #selector(doneClicked), for: .touchUpInside)
            cancelButton.showsTouchWhenHighlighted = true
            return cancelButton
        }()
        let charactersLeftLabel: UILabel = {
            let charactersLeftLabel = UILabel()
            charactersLeftLabel.text = text
            charactersLeftLabel.textColor = UIColor.lightGray
            return charactersLeftLabel
        }()
        accessory.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45)
        accessory.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        charactersLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.inputAccessoryView = accessory
        accessory.addSubview(cancelButton)
        accessory.addSubview(charactersLeftLabel)
        
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo:
                accessory.leadingAnchor, constant: 20),
            cancelButton.centerYAnchor.constraint(equalTo:
                accessory.centerYAnchor),
            charactersLeftLabel.centerXAnchor.constraint(equalTo:
                accessory.centerXAnchor),
            charactersLeftLabel.centerYAnchor.constraint(equalTo:
                accessory.centerYAnchor)
            ])
    }
    
    @objc func doneClicked() {
        self.resignFirstResponder()
    }
}

// MARK: - TextField

extension UITextField {
    func placeholderColor(_ color: UIColor){
        var placeholderText = ""
        if self.placeholder != nil{
            placeholderText = self.placeholder!
        }
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
    
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}

// MARK: - Notification Names

extension Notification.Name {
    static let PostsChangedNotification = Notification.Name("PostsChangedNotification")
}

