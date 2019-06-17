//
//  FBReportController.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/15/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation
import Firebase

class FBReportController {
    
    private let databaseReference = Database.database().reference()
    
    func createReport(from post: Post?, title: String, subTitle: String, reason: String, completion: @escaping (NetworkError?) -> Void) {
        guard let fbPost = post as? FBPost else {
            completion(.forwardedString(errorString: "Can't reference the post that you're trying to report")); return
        }
        let report = FbReport(title: title, subTitle: subTitle, reason: reason, postID: fbPost.uuid)
    
        guard let key = databaseReference.child("report").childByAutoId().key else { completion(.incorrectParameters); return }
        
        let values = ["/reports/\(key)": report.dictionaryRep, "/post-reports/\(fbPost.uuid)/\(key)/": report.dictionaryRep]
        
        databaseReference.child("report").updateChildValues(values) { (error, reference) in
            if let error = error {
                print("Error Creating Report \(error) \(error.localizedDescription)")
                completion(.forwarded(error))
            }
            completion(nil)
        }
    }
}
