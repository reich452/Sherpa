//
//  CloudKitPostController.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/27/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

protocol CommentUpdatedToDelegate: class {
    func commentsWereAddedTo()
}

class CloudKitPostController {
    
    static let shared = CloudKitPostController()
    
    private init() {}
    
    let publicDB = CKContainer.default().publicCloudDatabase
    weak var delegate: CommentUpdatedToDelegate?
    weak var timerDelegate: FetchAndUploadCounter?
    var counter = 0
    var totalCounter = 0
    let rTimer = RepeatingTimer(timeInterval: 1.0)
    
    var ckPosts = [CKPost]() {
        didSet {
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name.PostsChangedNotification, object: self)
            }
        }
    }
    
    
    // MARK: - CloudKit Availablity
    
    func checkAccountStatus(completion: @escaping (_ isLoggedIn: Bool?) -> ()) {
        CKContainer.default().accountStatus { [weak self] (status, error) in
            if let error = error {
                print("Error checking accountStatus \(error) \(error.localizedDescription)")
                completion(false); return
            } else {
                let errrorText = "Sign into iCloud in Settings"
                switch status {
                case .available:
                    completion(true)
                case .noAccount:
                    let noAccount = "No account found, Open Settings"
                    self?.presentErrorAlert(errorTitle: errrorText, errorMessage: noAccount)
                    completion(false)
                case .couldNotDetermine:
                    self?.presentErrorAlert(errorTitle: errrorText, errorMessage: "Error with iCloud account status, Open Settings")
                    completion(false)
                case .restricted:
                    self?.presentErrorAlert(errorTitle: errrorText, errorMessage: "Restricted iCloud account")
                    completion(false)
                }
            }
        }
    }
    
    func presentErrorAlert(errorTitle: String, errorMessage: String) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate,
                let appWindow = appDelegate.window!,
                let rootViewController = appWindow.rootViewController {
                rootViewController.showAlertMessage(titleStr: errorTitle, messageStr: errorMessage, actionString: "Settings", style: .default, completion: { (action) in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    } else {
                        print("bad url to settings app")
                    }
                })
            }
        }
    }
    
    func openSettingsApp() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        } else {
            print("bad url to settings app")
        }
    }
    
    // MARK: - Create
    
    func createPostWith(titleText: String, image: UIImage, completion: @escaping (CKPost?) -> ()){
        let ckPost = CKPost(title: titleText, image: image)
        self.ckPosts.insert(ckPost, at: 0)
        publicDB.save(CKRecord(ckPost)) { (_, error) in
            if let error = error {
                print("Error saving post record \(error) \(error.localizedDescription)")
                completion(nil);return
            }
            completion(ckPost)
        }
    }
    
    func addComent(_ text: String,to post: Post?, completion: @escaping (CKComment?) -> ()) {
        guard let post = post,
            let ckPost = post as? CKPost else {completion (nil); return }
        let ckComment = CKComment(text: text, ckPost: ckPost, post: post)
        ckPost.ckComments.append(ckComment)
        ckPost.comments.append(ckComment)
        ckComment.ckPost = ckPost
        
        publicDB.save(CKRecord(ckComment)) { (record, error) in
            if let error = error {
                print("Error saving comment to post \(error) \(error.localizedDescription)")
                completion(nil); return
            }
            DispatchQueue.main.async {
                self.delegate?.commentsWereAddedTo()
//                ckComment.recordID = record?.recordID
                completion(ckComment)
            }
        }
    }
    
    // MARK: - Fetch
    
    func fetchQueriedPosts(cursor: CKQueryOperation.Cursor? = nil, completion: @escaping (Bool, Int?) -> Void) {
      
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: CKPost.Constants.ckPostKey, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        let operation: CKQueryOperation
        
        if let cursor = cursor {
            operation = CKQueryOperation(cursor: cursor)
        } else {
            let predicate = NSPredicate(value: true)
            let query = CKQuery(recordType: CKPost.Constants.ckPostKey, predicate: predicate)
            query.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            operation = CKQueryOperation(query: query)
        }
        operation.desiredKeys = ["title", "imageData", "timestamp"]
        operation.resultsLimit = 5
        operation.queuePriority = .veryHigh
        operation.qualityOfService = .userInteractive
        rTimer.eventHandler = { [weak self] in
            guard let self = self else { return }
            self.counter += 1
        
            self.timerDelegate?.increaseTimer()
            print(" ⏲ Timer:  \(self.counter ??? "can't count")")
        }
        rTimer.resume()
        operation.recordFetchedBlock = { [unowned self] record in
            guard let post = CKPost(record: record) else { return }
            if self.ckPosts.contains(where: { (ckPost) -> Bool in
                post.recordID == ckPost.recordID
            }) {
                operation.cancel()
                self.rTimer.suspend()
                self.timerDelegate?.timerCompleted()
                completion(true, nil); return
            }
            self.ckPosts.append(post)
            print("🎃 fetching ckPosts \(self.ckPosts.count)")
            print(self.ckPosts.count)
            completion(false, nil)
    
            DispatchQueue.main.sync {

            }
        }
        
        operation.queryCompletionBlock = { [unowned self] cursor, error in
            if let error = error {
                print("Error fethcing posts \(error)")
            } else if let cursor = cursor {
                self.fetchQueriedPosts(cursor: cursor, completion: completion)
                print("Fetching more results \(self.ckPosts.count)")
            } else {
                print("Done Fetching CKPosts")
               
                self.rTimer.suspend()
                self.timerDelegate?.timerCompleted()
                self.totalCounter = self.counter
                completion(true, self.counter)
                
            }
        }
        publicDB.add(operation)
    }
    

    
    func fetchComments(from post: Post, completion: @escaping ([CKComment]?) -> Void) {
        guard let ckPost = post as? CKPost else { completion(nil); return }
        let postRef = ckPost.recordID
        let predicate = NSPredicate(format: "postReference == %@", postRef)
        let commentIDs = ckPost.ckComments.compactMap({$0.recordID})
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", commentIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        let query = CKQuery(recordType: "CKComment", predicate: compoundPredicate)
        
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching comments from cloudKit \(#function) \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let records = records else { completion(nil); return }
            let ckComments = records.compactMap{CKComment(record: $0)}
            ckPost.ckComments.append(contentsOf: ckComments)
            ckPost.ckComments = ckComments
            ckPost.comments = ckComments
            completion(ckComments)
        }
    }
}
