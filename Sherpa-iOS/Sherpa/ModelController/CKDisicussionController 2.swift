//
//  CKDisicussionController.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/24/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation
import CloudKit

class CKDiscussionController {
    
    typealias CKThoughtCompletion = (CKThought?, Error?) -> Void
    private let publicDB = CKContainer.default().publicCloudDatabase
    
    func createThought(author: String, title: String, body: String, completion: @escaping CKThoughtCompletion) {
        let ckThought = CKThought(author: author, title: title, body: body)
        publicDB.save(CKRecord(ckThought)) { (record, error) in
            if let error = error {
                debugPrint("Error saving CKThought Record \(error.localizedDescription)")
                completion(nil, error); return
            }
            completion(ckThought, nil)
        }
    }
    
    func fetchThoughts(completion: @escaping (_ result: Result<[Thought]?, Error>) -> Void) {
  
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "CKThought", predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                debugPrint("Error Fetching CKThought Record \(error.localizedDescription)")
                completion(.failure(error)); return
            }
            guard let records = records else { completion(.failure(NetworkError.noDataReturned)); return }
            
            var ckThoughts = records.compactMap({ CKThought($0) })
            ckThoughts.sort(by: {$0.timestamp > $1.timestamp})
            completion(.success(ckThoughts))
        }
    }
}
