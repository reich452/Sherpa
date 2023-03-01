//
//  FBComment.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/20/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation
import Firebase

struct FBComment: Comment {
    
    enum Constans {
        static let textKey = "text"
        static let timestampKey = "timestamp"
        static let postIDKey = "postID"
    }
   
    var text: String
    var author: String = ""
    var timestamp: Date = Date()
    var post: Post?
    let postID: String
    let timeInt: Int
    
    var dictionaryRep: [String: Any] {
        return [
            Constans.textKey : self.text,
            Constans.timestampKey : self.timeInt,
            Constans.postIDKey : self.postID
        ]
    }
}

extension FBComment {
    
    init(text: String, postID: String, timeInt: Int = Int(NSDate().timeIntervalSince1970 * 1000)) {
        self.text = text
        self.postID = postID
        self.timeInt = timeInt
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dictionary = snapshot.value as? [String: Any] else { return nil }
        guard let text = dictionary[Constans.textKey] as? String,
            let postID = dictionary[Constans.postIDKey] as? String,
            let timeInt = dictionary[Constans.timestampKey] as? Int else { return nil }
        
        self.text = text
        self.postID = postID
        self.timeInt = timeInt
    }
}
