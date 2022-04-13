//
//  FbReport.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/14/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation

struct FbReport: Report {
    
    enum Constans {
        static let titleKey = "title"
        static let subTitleKey = "subTitle"
        static let reasonKey = "reason"
        static let postIDKey = "postID"
        static let timeStampKey = "timestamp"
    }
    
    var title: String
    var subTitle: String? = nil
    var reason: String
    var postID: String
    var post: Post?
    let timestamp: Date = Date()
    let timeInt: Int

    init(title: String, subTitle: String?, reason: String, postID: String, timeInt: Int = Int(NSDate().timeIntervalSince1970 * 1000)) {
        self.title = title
        self.subTitle = subTitle
        self.reason = reason
        self.postID = postID
        self.timeInt = timeInt
        
    }
    var dictionaryRep: [String: Any] {
        return [
            Constans.titleKey : self.title,
            Constans.reasonKey : self.reason,
            Constans.postIDKey : self.postID,
            Constans.timeStampKey : self.timeInt
        ]
    }
}

