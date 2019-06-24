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
        case text = "text"
        case timestamp = "timestamp"
        case database = "database"
    }
    
    var author: String
    var text: String
    var timestamp: Date = Date()
    var database: DataBase = .cloudKit
    var comments: [Comment] = []
    let recordID: CKRecord.ID = CKRecord.ID.init(recordName: UUID().uuidString)
}

extension CKThought {
    
    init(text: String, author: String) {
        self.text = text
        self.author = author
    }
    
    init?(_ ckRecord: CKRecord) {
        guard let text = ckRecord[Keys.text.rawValue] as? String,
            let timestamp = ckRecord[Keys.timestamp.rawValue] as? Date,
            let author = ckRecord[Keys.author.rawValue] as? String else { return nil }
        
        self.text = text
        self.timestamp = timestamp
        self.author = author
        self.comments = []
    }
}

extension CKRecord {
    
    convenience init(_ ckThought: CKThought) {
        self.init(recordType: CKThought.Keys.ckThought.rawValue, recordID: ckThought.recordID)
        self.setValue(ckThought.text, forKey: CKThought.Keys.text.rawValue)
        self.setValue(ckThought.timestamp, forKey: CKThought.Keys.timestamp.rawValue)
    }
}
