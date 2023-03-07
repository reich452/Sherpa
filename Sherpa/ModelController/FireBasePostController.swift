//
//  FireBasePostController.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import Firebase
import FirebaseStorage
import UIKit

// TODO: - Move to protocol oriented to make DI easier for UnitTests
protocol FireBasePostProviding: AnyObject {
    func createPost(with title: String, image: UIImage, completion: @escaping FireBasePostController.FBCompletion)
    func fetchPosts(completion: @escaping FireBasePostController.FBCompletion)
    func fetchImage(post: Post, completion: @escaping (UIImage?) -> Void)
}

final class FireBasePostController: FireBasePostProviding {
  
    // MARK: - Properties
    typealias FBCompletion = (Bool, NetworkError?) -> Void
    
    // Wow. This is no good. Haven't looked at this code in 4 or 5 years.
    // Wild to look back.
    // These properties should be taken out of this class.
    weak var timerDelegate: FetchAndUploadCounter?
    var fbPosts = [FBPost]()
    var myTimer = MyTimer()
    var timeElapsed = 0.0
    var rTimer = RepeatingTimer(timeInterval: 0.1)
    
    private let databaseReference: DatabaseReference
    private let storageProviding: StorageProviding
    
    init(databaseReference: DatabaseReference = Database.database().reference(),
         storageProviding: StorageManager = StorageManager(storageRef: Storage.storage().reference())) {
        self.databaseReference = databaseReference
        self.storageProviding = storageProviding
    }
    
    // MARK: - CRUD
    
    func createPost(with title: String, image: UIImage, completion: @escaping FBCompletion) {
         guard let imageData = image.jpegData(compressionQuality: 0.2) else { completion(false, NetworkError.noDataReturned) ; return }
        let filename = UUID().uuidString
        
        rTimer.resume()
        rTimer.eventHandler = { [weak self] in
            guard let self = self else { return }
            self.timeElapsed += 0.1
            self.timerDelegate?.increaseFbUploadTimer(time: self.timeElapsed)
            debugPrint(" ⏲ Timer:  \(self.timeElapsed ??? "can't count")")
        }
        storageProviding.uploadData(imageData, named: "images/shera.jpg", file: filename, contentType: .imageJpeg) { [weak self] (url, error) in
            guard let self = self else { return }
            if let error = error {
                debugPrint("Error saving image to firebase storage \(error) \(error.localizedDescription)")
                completion(false, .forwarded(error)); return
            }
            
            guard let url = url else {completion(false, NetworkError.noDataReturned); return }
            guard let key = self.databaseReference.child("posts").childByAutoId().key else { completion(false, NetworkError.incorrectParameters); return }
            
            let urlString = url.absoluteString
            let fbPost = FBPost(title: title, imageStringURL: urlString, uuid: key)
            let values = [key : fbPost.dictionaryRep]
            self.fbPosts.insert(fbPost, at: self.fbPosts.startIndex)
            self.databaseReference.child("posts").updateChildValues(values, withCompletionBlock: { (error, ref) in
                if let error = error {
                    debugPrint("Error updating nodes: \(error)")
                    self.rTimer.suspend()
                    completion(false, .forwarded(error)); return
                }
                self.rTimer.suspend()
                self.timerDelegate?.timerCompleted()
                completion(true, nil)
            })
        }
    }
    
    // MARK: - Fetch
    
    func fetchPosts(completion: @escaping FBCompletion) {
        let query = databaseReference.child("posts").queryOrdered(byChild: "timestamp")
        myTimer.startTimer()
        timerDelegate?.increaseFetchTimer()
    
        query.observe(.value) { [weak self] (snapshot) in
            guard let self = self else { return }
            for post in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
                guard let fbPost = FBPost(snapshot: post) else { completion(false, nil); return }
                self.fbPosts.append(fbPost)
            }
            self.fbPosts.sort(by: { $0.timestamp > $1.timestamp })
            completion(true, nil)
        }
    }
    
    func fetchImage(post: Post, completion: @escaping (UIImage?) -> Void) {
        guard let fbPost = post as? FBPost,
            let url = URL(string: fbPost.imageStringURL) else { completion(nil) ; return }
        self.myTimer.increaseCounter()
        self.timerDelegate?.increaseFetchTimer()

        URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let self = self else { return }
            if let error = error {
                debugPrint("❌Error fetching image for FB User: \(error.localizedDescription)")
                completion(nil); return
            }
            guard let data = data,
                let image = UIImage(data: data) else { completion(nil) ; return }
          
            self.timerDelegate?.timerCompleted()
            fbPost.image = image
            
            completion(image)
            }.resume()
    }
}

