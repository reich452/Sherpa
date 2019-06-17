//
//  CKReportController.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/17/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation
import CloudKit

class CKReportController {
    
    // MARK: - Create Report
    private let publicDB = CKContainer.default().publicCloudDatabase
    
    func createReport(with title: String, subTitle: String?, reason: String, fromPost: Post, completion: @escaping (Bool, Error?) -> Void) {
        guard let ckPost = fromPost as? CKPost else { return }
        let ckReport = CKReport(title: title, subTitle: subTitle, reason: reason, postID: ckPost.recordID.recordName, ckPost: ckPost)
        
        publicDB.save(CKRecord(ckReport)) { (record, error) in
            if let error = error {
                print("Error saving comment to post \(error) \(error.localizedDescription)")
                completion(false, error); return
            }
            
            completion(true, nil)
        }
    }
}
