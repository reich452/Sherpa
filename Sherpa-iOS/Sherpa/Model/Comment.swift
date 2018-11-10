//
//  Comment.swift
//  Sherpa
//
//  Created by Nick Reichard on 11/9/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import Foundation

protocol Comment {
    var text: String { get set }
    var author: String { get set }
    var timestamp: Date { get set }
}
