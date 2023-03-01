//
//  Vote.swift
//  Sherpa
//
//  Created by Nick Reichard on 8/8/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation
import Firebase

struct Vote {
    
    var firebaseCount: Int
    var cloudKitCount: Int
    
    mutating func addedFirebaseVote() {
        self.firebaseCount += 1
    }
    
    mutating func subtractedFirebaseVote() {
        self.firebaseCount -= 1
    }
    
    mutating func addedCloudKitVote() {
        self.cloudKitCount += 1
    }
    
    mutating func subtractedCloudKitVote() {
        self.cloudKitCount -= 1
    }
    
    var dictionaryRep: [String: Any] {
        return ["firebaseCount" : self.firebaseCount, "cloudKitCount": self.cloudKitCount]
    }
}

extension Vote {
    
    init?(snapShot: DataSnapshot) {
        guard let dic = snapShot.value as? [String: Any] else { return nil }
        guard let fbCount = dic["firebaseCount"] as? Int,
            let ckCount = dic["cloudKitCount"] as? Int else { return nil }
        
        self.firebaseCount = fbCount
        self.cloudKitCount = ckCount
    }
}
