//
//  FBCommentController.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/20/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation
import Firebase

class FBCommnetController {

    private let databaseReference = Database.database().reference()
    
    func addCommentTo(post: Post, text: String, completion: @escaping (FBComment?, NetworkError?) -> Void) {
        guard let fbPost = post as? FBPost else {
            completion(nil,.forwardedString(errorString: "Can't reference the post that you're trying to report")); return
        }
        
        let fbComment = FBComment(text: text, postID: fbPost.uuid)
        
          guard let key = databaseReference.child("fbComment").childByAutoId().key else { completion(nil, .incorrectParameters); return }
        
        let values = ["/fbComments/\(key)": fbComment.dictionaryRep, "/post-fbComments/\(fbPost.uuid)/\(key)/": fbComment.dictionaryRep]
        databaseReference.child("fbComment").updateChildValues(values) { (error, reference) in
            if let error = error {
                debugPrint("Error Creating Report \(error) \(error.localizedDescription)")
                completion(nil,.forwarded(error))
            }
            fbPost.comments.append(fbComment)

            completion(fbComment, nil)
        }
    }
    
    func fetchFBComments(from post: Post, completion: @escaping ([FBComment]?, NetworkError?) -> Void) {
        guard let fbPost = post as? FBPost else { return }
        debugPrint("The TITLE IS \(post.title)")
         let query = databaseReference.child("fbComment").child("post-fbComments").child(fbPost.uuid).queryOrdered(byChild: "timestamp")
        
        var fbComments: [FBComment] = []
        query.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children.allObjects as! [DataSnapshot] {

                guard let fbComment = FBComment(snapshot: snap) else { return }
                fbComments.append(fbComment)
            }
            completion(fbComments, nil)
        }
    }
}
