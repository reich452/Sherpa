//
//  CKReport.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/14/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation
import CloudKit

class CKReport: Report {
    
    fileprivate let titleKey = "Title"
    fileprivate let subTitleKey = "SubTitle"
    fileprivate let reasonKey = "Reason"
    fileprivate let postReferenceKey = "postReference"
    
    var title: String
    var subTitle: String?
    var reason: String
    var postID: String
    var ckPost: CKPost?
    var post: Post? = nil
    let recordID = CKRecord.ID(recordName: UUID().uuidString)
    
    required init(title: String, subTitle: String?, reason: String, postID: String) {
        self.title = title
        self.subTitle = subTitle
        self.reason = reason
        self.postID = postID
        self.ckPost = nil
    }
    
}

extension CKReport {
    convenience init(title: String, subTitle: String?, reason: String, postID: String, ckPost: CKPost?) {
        self.init(title: title, subTitle: subTitle, reason: reason, postID: postID)
        self.ckPost = ckPost
    }
}

extension CKRecord {
    
    convenience init(_ ckReport: CKReport) {
        guard let ckPost = ckReport.ckPost else {
            fatalError("Relationship has not been set")
        }
        self.init(recordType: "Report", recordID: ckReport.recordID)
        self.setValue(ckReport.title, forKey: ckReport.titleKey)
        self.setValue(ckReport.subTitle, forKey: ckReport.subTitleKey)
        self.setValue(ckReport.reason, forKey: ckReport.reasonKey)
        self.setValue(CKRecord.Reference(recordID: ckPost.recordID, action: .deleteSelf), forKey: ckReport.postReferenceKey)
    }
}
