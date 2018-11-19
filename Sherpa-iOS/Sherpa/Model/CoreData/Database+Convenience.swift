//
//  CoreData+Convenience.swift
//  Sherpa
//
//  Created by Nick Reichard on 11/14/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import Foundation
import CoreData

extension AuthorModel {
    
    @discardableResult convenience init(name: String, detail: String, pro: String, con: String, rating: Int16, opinion: String, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.detail = detail
        self.pro = pro
        self.con = con
        self.rating = rating
        self.opinion = opinion
    }
}

enum RatingEnum: Int16 {
    case zero = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
}


extension AuthorModel {
    var ratingEnum: RatingEnum {
        set {
            self.rating = newValue.rawValue
        } get {
            return RatingEnum(rawValue: self.rating) ?? .zero
        }
    }
}
