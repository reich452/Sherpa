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
    weak var timerDelegate: FetchAndUploadCounter?
    var rTimer = RepeatingTimer(timeInterval: 0.1)

    // MARK: - Firebase Ref
    private let databaseReference = Database.database().reference()
    private let storageReference = Storage.storage().reference()
    
    // TODO: - Use storage manager instead
    let myTimer: MyTimer
    private let storageManager: StorageManager
    init(storageManager: StorageManager, myTimer: MyTimer) {
        self.storageManager = storageManager
        self.myTimer = myTimer
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
        timerDelegate?.increaseTimer()
        rTimer.resume()
        query.observe(.value) { [weak self] (snapshot) in
            guard let self = self else { return }
            for post in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
                guard let fbPost = FbPost(snapshot: post) else { return }
                self.fbPosts.append(fbPost)
            }
            self.timerDelegate?.timerCompleted()
            completion(true, nil)
        }
        
    }
    
    func fetchImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { completion(nil) ; return }
        self.timerDelegate?.increaseTimer()
        rTimer.resume()
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("❌Error fetching image for FB User: \(error.localizedDescription)")
            }
            guard let data = data,
                let image = UIImage(data: data) else { completion(nil) ; return }
          
            self.timerDelegate?.timerCompleted()
            completion(image)
            }.resume()
    }
    
}

class MyTimer {
    
    // MARK: - Properties
    
    let startTime:CFAbsoluteTime
    var endTime:CFAbsoluteTime?
    var counter = 0.0
    var isRunning = false
    var timer = Timer()
    
    init() {
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    // MARK: - Absolute Time
    
    func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()
        
        return duration!
    }
    
    var duration:CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
    
    // MARK: - Timer class
    
    func startTimer() {
        if !isRunning {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
            isRunning = true
        }
    }

    @objc func runTimer() -> String {
        counter += 0.1
        let flooredCounter = Int(floor(counter))
        
        let second = (flooredCounter % 3600) % 60
        var secondString = "\(second)"
        if second < 10 {
            secondString = "\(second)"
        }
        print(" +++++ MY counter is \(counter) +++++")
        let decisecond = String(format: "%.1f", counter).components(separatedBy: ".").last!
        
        return "\(secondString).\(decisecond)"
    }
    
    // MARK: - Stop
    
    func stopTimer() {
        timer.invalidate()
        isRunning = false
    }
    
    func resetTimer() {
        timer.invalidate()
        isRunning = false
        counter = 0.0
    }
    
}
