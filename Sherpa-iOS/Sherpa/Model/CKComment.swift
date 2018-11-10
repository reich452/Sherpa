//
//  CKComment.swift
//  Sherpa
//
//  Created by Nick Reichard on 11/9/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import Foundation
import CloudKit

struct CKComment: Comment {
    
    let typeKey = "CKComment"
    fileprivate let textKey = "text"
    fileprivate let timestampKey = "timstamp"
    fileprivate let postReferenceKey = "postReference"
   
    var recordID = CKRecord.ID(recordName: UUID().uuidString)
    var text: String
    var author: String = ""
    var timestamp: Date
    var ckPost: CKPost?
    
    init(text: String, timestamp: Date = Date(), ckPost: CKPost?) {
        self.text = text
        self.timestamp = timestamp
        self.ckPost = ckPost
    }
    
    init?(record: CKRecord) {
        guard let text = record["text"] as? String,
            let timestamp = record.creationDate else { return nil }
        self.init(text: text, timestamp: timestamp, ckPost: nil)
        self.recordID = record.recordID
    }
    
    mutating func addComment(ckComment: CKComment) {
       ckPost?.comments.append(ckComment)
    }
    
}

extension CKRecord {
    convenience init(_ comment: CKComment) {
        guard let post = comment.ckPost else {
            fatalError("Comment does not have a Post relationship")
        }
        self.init(recordType: comment.typeKey, recordID: comment.recordID)
        self.setValue(comment.text, forKey: comment.textKey)
        self.setValue(comment.timestamp, forKey: comment.timestampKey)
        self.setValue(CKRecord.Reference(recordID: post.recordID, action: .deleteSelf), forKey: comment.postReferenceKey)
    }
}
