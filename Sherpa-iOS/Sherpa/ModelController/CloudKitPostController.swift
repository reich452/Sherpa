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

class CloudKitPostController{
    
    static let shared = CloudKitPostController()
    
    private init() {}
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
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
                    guard let settingsUrl = URL(string: PreferenceType.castle.rawValue) else {
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
        guard let settingsUrl = URL(string: PreferenceType.castle.rawValue) else { return }
        
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
    
    func addComent(_ text: String, to ckPost: CKPost, completion: @escaping (CKComment?) -> ()) {
        var ckComment = CKComment(text: text, ckPost: ckPost)
        ckComment.addComment(ckComment: ckComment)
        publicDB.save(CKRecord(ckComment)) { (record, error) in
            if let error = error {
                print("Error saving comment to post \(error) \(error.localizedDescription)")
                completion(nil); return
            }
            completion(ckComment)
        }
    }
    
    // MARK: - Fetch
    
    func fetchQueriedPosts(cursor: CKQueryOperation.Cursor? = nil, completion: @escaping (Bool) -> Void) {
        
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
        
        operation.recordFetchedBlock = { [unowned self] record in
            guard let post = CKPost(record: record) else { return }
            self.ckPosts.append(post)
            print("🎃 fetching ckPosts \(self.ckPosts.count)")
            print(self.ckPosts.count)
            completion(false)
            DispatchQueue.main.sync {
                // TODO: - switch back to delegate
//                self.delegate?.postsWereAddedTo()
            }
        }
        let publicDB = CKContainer.default().publicCloudDatabase
        operation.queryCompletionBlock = { [unowned self] cursor, error in
            if let error = error {
                print("Error fethcing posts \(error)")
            } else if let cursor = cursor {
                self.fetchQueriedPosts(cursor: cursor, completion: completion)
                print("Fetching more results \(self.ckPosts.count)")
            } else {
                print("Done Fetching CKPosts")
                completion(true)
            }
        }
        publicDB.add(operation)
    }
    
}

