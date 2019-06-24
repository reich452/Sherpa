//
//  Thought.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/23/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation

protocol Thought {
    var author: String { get set }
    var text: String { get set }
    var timestamp: Date { get set }
    var database: DataBase { get set }
    var comments: [Comment] { get set }
}
