//
//  FireBasePostController.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import Foundation
import Firebase

class FireBasePostController {
    
    // MARK: - Properties
    typealias fbCompletion = (Bool, NetworkError?) -> Void
    var fbPosts = [FbPost]()
    
    // MARK: - Firebase Ref
    private let databaseReference = Database.database().reference()
    private let storageReference = Storage.storage().reference()
    
    // TODO: - Use storage manager instead
    private let storageManager: StorageManager
    init(storageManager: StorageManager) {
        self.storageManager = storageManager
    }
    
    // MARK: - CRUD
    
    func createPost(with title: String, image: UIImage, completion: @escaping fbCompletion) {
         guard let imageData = image.jpegData(compressionQuality: 0.3) else { completion(false, NetworkError.noDataReturned) ; return }
        let filename = UUID().uuidString
        storageManager.uploadData(imageData, named: "images/shera.jpg", file: filename, contentType: .imageJpeg) { (url, error) in
            if let error = error {
                print("Error saving image to firebase storage \(error) \(error.localizedDescription)")
                completion(false, .forwarded(error)); return
            }
            
            guard let url = url else {completion(false, NetworkError.noDataReturned); return }
            
            guard let key = self.databaseReference.child("posts").childByAutoId().key else { completion(false, NetworkError.incorrectParameters); return }
            
            let urlString = url.absoluteString
            let fbPost = FbPost(title: title, imageStringURL: urlString)
            let values = [key : fbPost.dictionaryRep]
            
            self.databaseReference.child("posts").updateChildValues(values, withCompletionBlock: { (error, ref) in
                if let error = error {
                    print("Error updating nodes: \(error)")
                    completion(false, .forwarded(error)); return
                }
                completion(true, nil)
            })
        }
    }
    
    // MARK: - Fetch
    
    func fetchPosts(completion: @escaping fbCompletion) {
        let query = databaseReference.child("posts")
        query.observe(.value) { (snapshot) in
            for post in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
                guard let fbPost = FbPost(snapshot: post) else { return }
                self.fbPosts.append(fbPost)
            }
            completion(true, nil)
        }
    }
    
    func fetchImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { completion(nil) ; return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("❌Error fetching image for FB User: \(error.localizedDescription)")
            }
            guard let data = data,
                let image = UIImage(data: data) else { completion(nil) ; return }
            completion(image)
            }.resume()
    }
    
}