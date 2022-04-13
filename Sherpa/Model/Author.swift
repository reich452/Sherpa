//
//  AuthorModel.swift
//  Sherpa
//
//  Created by Nick Reichard on 12/16/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import Foundation

struct Author {
    
    let name: String
    let detail: String
    let pro: String
    let con: String
    var rating: Int
    let opinion: String
}

enum RatingEnum: Int {
    case zero = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
}

extension Author {
    var ratingEnum: RatingEnum {
        set {
            self.rating = newValue.rawValue
        } get {
            return RatingEnum(rawValue: self.rating) ?? .zero
        }
    }
}
extension Author {
    func matches(searchTerm: String) -> Bool {
        if name.lowercased().contains(searchTerm.lowercased()){
            return true
        }
        return false
    }
}
