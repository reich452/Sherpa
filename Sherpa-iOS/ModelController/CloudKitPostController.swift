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

extension CloudKitPostController {
    static let PostsChangedNotification = Notification.Name("PostsChangedNotification")
}

protocol PostsWereAddedToDelegate: class {
    func postsWereAddedTo()
}

class CloudKitPostController{
    
    static let shared = CloudKitPostController()
    
    private init() {}
    
    let publicDB = CKContainer.default().publicCloudDatabase
    weak var delegate: PostsWereAddedToDelegate?
    
    var posts = [CKPost]() {
        didSet {
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: CloudKitPostController.PostsChangedNotification, object: self)
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
        self.posts.append(ckPost)
        publicDB.save(CKRecord(ckPost)) { (_, error) in
            if let error = error {
                print("Error saving post record \(error) \(error.localizedDescription)")
                completion(nil);return
            }
            completion(ckPost)
        }
    }
    
    // MARK: - Fetch
    func fetchAllPostsFromCloudKit(completion: @escaping([CKPost]?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Post", predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            
            if let error = error {
                print("Error fetching posts from cloudKit \(#function) \(error) \(error.localizedDescription)")
                completion(nil);return
            }
            
            guard let records = records else {completion(nil); return }
            
            let posts = records.compactMap{CKPost(record: $0)}
            
            self.posts = posts
            completion(posts)
        }
    }
    
    func fetchQueriedPosts(cursor: CKQueryOperation.Cursor? = nil) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Post", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        let operation: CKQueryOperation
        
        if let cursor = cursor {
            operation = CKQueryOperation(cursor: cursor)
        } else {
            let predicate = NSPredicate(value: true)
            let query = CKQuery(recordType: "Post", predicate: predicate)
            query.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            operation = CKQueryOperation(query: query)
        }
        operation.desiredKeys = ["caption", "photoData", "timestamp"]
        operation.resultsLimit = 5
        operation.queuePriority = .veryHigh
        operation.qualityOfService = .userInteractive
        
        operation.recordFetchedBlock = { [unowned self] record in
            guard let post = CKPost(record: record) else { return }
            self.posts.append(post)
            print("🎃 \(Thread.isMainThread)")
            print(self.posts.count)
            DispatchQueue.main.sync {
                print("SYNC \(Thread.isMainThread)")
                self.delegate?.postsWereAddedTo()
            }
        }
        let publicDB = CKContainer.default().publicCloudDatabase
        operation.queryCompletionBlock = { [unowned self] cursor, error in
            if let error = error {
                print("Error fethcing posts \(error)")
            } else if let cursor = cursor {
                self.fetchQueriedPosts(cursor: cursor)
                print("Fetching more results \(self.posts.count)")
            } else {
                print("Done")
                DispatchQueue.main.async {
                    
                }
            }
        }
        
        publicDB.add(operation)
    }
    
}

