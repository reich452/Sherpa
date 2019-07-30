//
//  FBDiscussion.swift
//  Sherpa
//
//  Created by Nick Reichard on 7/30/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation
import Firebase

struct FBDiscussionController {
    
    private let databaseReference = Database.database().reference()
    
    func createFBThought(author: String, title: String, body: String, completion: @escaping (_ result: Result<FBThought, Error>) -> Void) {
        
        let thought = FBThought(author: author, title: title, body: body, uuid: UUID().uuidString)
        guard let key = databaseReference.child("thought").childByAutoId().key else { completion(.failure(NetworkError.incorrectParameters)); return }
        let values = [key: thought.dictionaryRep]
        databaseReference.child("thought").updateChildValues(values) { (error, nil) in
            if let error = error {
                print("Error in \(#function) \(error) \(error.localizedDescription)")
                completion(.failure(NetworkError.forwarded(error))); return
            } else {
                completion(.success(thought))
            }
        }
    }
    
    func fetchFBThoughts(completion: @escaping (_ result: Result<[Thought]?, Error>) -> Void) {
        var thoughts: [Thought] = []
        let query = databaseReference.child("thought").queryOrdered(byChild: "timestamp")
        query.observe(.value) { (snapshot) in
            
            for thought in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
              
                guard let fbThought = FBThought(snapShot: thought) else { completion(.failure(NetworkError.dataNotDecodable)); return }
                
                thoughts.append(fbThought)
            }
            thoughts.sort(by: { $0.timestamp > $1.timestamp })
            completion(.success(thoughts))
        }
    }
}
