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
    static let shared = FireBasePostController()
    private init(){}
    typealias fbCompletion = (Bool, NetworkError?) -> Void
    var fbPosts = [FbPost]()
    
    // MARK: - Firebase Ref
    private let databaseReference = Database.database().reference()
    private let storageReference = Storage.storage().reference()
    
    // TODO: - Use storage manager instead
//    private let storageManager: StorageManager
//    init(storageManager: StorageManager) {
//        self.storageManager = storageManager
//    }
    
    // MARK: - CRUD
    
    func createPost(with title: String, image: UIImage, completion: @escaping fbCompletion) {
         guard let imageData = image.jpegData(compressionQuality: 0.3) else { completion(false, NetworkError.noDataReturned) ; return }
        let storageRef = storageReference.child("images/sherpa.jpg")
//        let st = storageReference.
        storageRef.putData(imageData, metadata: nil) { (metaData, error) in

            if let error = error {
                print("Error saving image to firebase storage \(error) \(error.localizedDescription)")
                completion(false, .forwarded(error)); return
            }
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error downloading image url:  \(error) \(error.localizedDescription)")
                    completion(false, .forwarded(error)); return
                }
                guard let imageUrl = url?.absoluteString else { completion(false, .forwardedString(errorString: "bad string url")); return }

                let uuidString = UUID().uuidString
                let fbPost = FbPost(title: title, imageStringURL: imageUrl + uuidString)
               
                self.databaseReference.child("posts").childByAutoId().updateChildValues(fbPost.dictionaryRep)
                completion(true, nil)
            }
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
