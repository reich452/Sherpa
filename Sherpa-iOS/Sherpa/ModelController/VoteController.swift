//
//  VoteController.swift
//  Sherpa
//
//  Created by Nick Reichard on 8/8/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation
import Firebase

enum DBVoteKey: String {
    case firebaseCount
    case cloudKitCount
}

final class VoteController {
    
    private let databaseReference = Database.database().reference()
    private let userDefaults = UserDefaults.standard
    
    func didVoteForCloudKit() -> Bool {
        if userDefaults.value(forKey: DBVoteKey.cloudKitCount.rawValue) as? Bool == true {
            return true
        }
        return false
    }
    
    func didVoteForFirebase() -> Bool {
        if userDefaults.value(forKey: DBVoteKey.firebaseCount.rawValue) as? Bool == true {
            return true
        }
        return false
    }
    
    func fetchVoteCount(compeletion: @escaping (Result<Vote, Error>) -> Void) {
        
        let query = databaseReference.child("vote")
        
        query.observeSingleEvent(of: .value) { (snap) in
            
            guard let vote = Vote(snapShot: snap) else { compeletion(.failure(NetworkError.dataNotDecodable)); return }
            compeletion(.success(vote))
        }
    }
    
    
    // MARK: - Update
    
    func updateVote(dbVoteKey: DBVoteKey, compeletion: @escaping (Result<Bool, Error>) -> Void, didVoteCompletion: @escaping (String) -> Void) {
        
        if didVoteForCloudKit() == true || didVoteForFirebase() == true {
            didVoteCompletion("You've Already Voted"); return 
        }
        
        self.databaseReference.child("vote").child(dbVoteKey.rawValue).runTransactionBlock({ (mutableData) -> TransactionResult in
            
            if let data = mutableData.value as? Int {
                mutableData.value = data + 1
                return TransactionResult.success(withValue: mutableData)
            } else {
                return TransactionResult.success(withValue: mutableData)
            }
            
        }, andCompletionBlock: { [weak self] (error, bool, snap) in
            if let error = error {
                print("Error updating vote count: \(#function) \(error) \(error.localizedDescription)")
                compeletion(.failure(error))
            }
            if !bool {
                print("Cannot Complete vote updates")
            } else {
                self?.userDefaults.set(true, forKey: dbVoteKey.rawValue)
                compeletion(.success(true))
            }
            
            }, withLocalEvents: false)
    }
}


