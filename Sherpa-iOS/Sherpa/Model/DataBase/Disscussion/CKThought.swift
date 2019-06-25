//
//  CKThought.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/24/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation
import CloudKit

struct CKThought: Thought {
    
    enum Keys: String {
        case ckThought = "CKThought"
        case author = "author"
        case title = "title"
        case body = "body"
        case timestamp = "timestamp"
        case database = "database"
    }
    
    var author: String
    var title: String
    var body: String
    var timestamp: Date = Date()
    var database: DataBase = .cloudKit
    var comments: [Comment] = []
    let recordID: CKRecord.ID = CKRecord.ID.init(recordName: UUID().uuidString)
}

extension CKThought {
    
    init(author: String, title: String, body: String) {
        self.author = author
        self.title = title
        self.body = body
    }
    
    init?(_ ckRecord: CKRecord) {
        guard let body = ckRecord[Keys.body.rawValue] as? String,
            let title = ckRecord[Keys.title.rawValue] as? String,
            let timestamp = ckRecord[Keys.timestamp.rawValue] as? Date,
            let author = ckRecord[Keys.author.rawValue] as? String else { return nil }
        
        self.author = author
        self.title = title
        self.timestamp = timestamp
        self.body = body
        self.comments = []
    }
}

extension CKRecord {
    
    convenience init(_ ckThought: CKThought) {
        self.init(recordType: "CKThought", recordID: ckThought.recordID)
        self.setValue(ckThought.author, forKey: CKThought.Keys.author.rawValue)
        self.setValue(ckThought.title, forKey: CKThought.Keys.title.rawValue)
        self.setValue(ckThought.body, forKey: CKThought.Keys.body.rawValue)
        self.setValue(ckThought.timestamp, forKey: CKThought.Keys.timestamp.rawValue)
    }
}
