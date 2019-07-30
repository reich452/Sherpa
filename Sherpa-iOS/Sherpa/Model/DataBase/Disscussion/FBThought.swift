//
//  FBThought.swift
//  Sherpa
//
//  Created by Nick Reichard on 7/30/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation
import Firebase

struct FBThought: Thought {
    
    var author: String
    var title: String
    var body: String
    var timestamp: Date = Date()
    var database: DataBase = .firebase
    var comments: [Comment] = []
    var timeInt: Int
    var uuid: String
    
    enum Keys: String {
        case author = "author"
        case title = "title"
        case body = "body"
        case timestamp = "timestamp"
        case uuid = "uuid"
    }
    
    var dictionaryRep: [String: Any] {
        return [
            Keys.author.rawValue : self.author,
            Keys.title.rawValue : self.title,
            Keys.body.rawValue : self.body,
            Keys.timestamp.rawValue : self.timeInt,
            Keys.uuid.rawValue : self.uuid
        ]
    }
}

extension FBThought {
    
    init(author: String, title: String, body: String, timeInt: Int = Int(NSDate().timeIntervalSince1970 * 1000), uuid: String) {
        self.author = author
        self.title = title
        self.body = body
        self.timeInt = timeInt
        self.uuid = uuid
    }
    
    init?(snapShot: DataSnapshot) {
        guard let dic = snapShot.value as? [String: Any],
            let author = dic[Keys.author.rawValue] as? String,
            let title = dic[Keys.title.rawValue] as? String,
            let body = dic[Keys.body.rawValue] as? String,
            let uuid = dic[Keys.uuid.rawValue] as? String,
            let timeInt = dic[Keys.timestamp.rawValue] as? Int else { return nil }
        
        self.author = author
        self.title = title
        self.body = body
        self.uuid = uuid
        self.timeInt = timeInt
    }
}
