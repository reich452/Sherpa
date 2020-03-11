//
//  CustomFont.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/27/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

enum CustomFonts: String {
    case zapfino = "Zapfino"
    case gotham = "Georgia"
    case helvetica = "Helvetica"
    case helveticaBold = "Helvetica Bold"
    
    func of(size: CGFloat) -> UIFont {
        return  UIFont(name: self.rawValue, size: size) ?? UIFont()
    }
}
