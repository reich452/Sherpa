//
//  Report.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/13/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation
import CloudKit

protocol Report {
    var title: String { get }
    var subTitle: String? { get }
    var reason: String { get }
    var postID: String { get }
}

struct CKReport: Report {
    
    fileprivate let titleKey = "Title"
    fileprivate let subTitleKey = "SubTitle"
    fileprivate let reasonKey = "Reason"
    fileprivate let idKey = "PostId"
    
    var title: String
    var subTitle: String?
    var reason: String
    var postID: String
    var ckPost: CKPost?
    let recordID = CKRecord.ID(recordName: UUID().uuidString)
}

extension CKRecord {
    
    convenience init(_ report: CKReport) {
        guard let ckPost = report.ckPost else {
            fatalError("Relationship has not been set")
        }
        let recordID = ckPost.recordID
        self.init(recordType: report.idKey, recordID: recordID)
        self.setValue(report.title, forKey: report.titleKey)
        self.setValue(report.subTitle, forKey: report.subTitleKey)
        self.setValue(ckPost.recordID.recordName, forKey: report.idKey)
    }
}

struct FBReport: Report {
    
    var title: String
    var subTitle: String?
    var reason: String
    var postID: String
    
}
