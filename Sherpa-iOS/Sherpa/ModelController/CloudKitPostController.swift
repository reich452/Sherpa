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
    
    deinit {
        rTimer.suspend()
    }
    
    private let rTimer = RepeatingTimer(timeInterval: 0.1)
    private var imageCache = NSCache<CKRecord.ID, NSURL>()
    weak var delegate: CommentUpdatedToDelegate?
    weak var timerDelegate: FetchAndUploadCounter?
    let publicDB = CKContainer.default().publicCloudDatabase
    let myTimer = MyTimer()
    var fetchCounter = 0.0
    var uploadCounter = 0.0
    var totalCounter = 0.0
    var ckPosts = [CKPost]()
    
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
        
        self.rTimer.resume()
        rTimer.eventHandler = { [weak self] in
            guard let self = self else { return }
            self.uploadCounter += 0.1
            self.timerDelegate?.increaseCkUploadTimer(time: self.uploadCounter)
        }
        self.ckPosts.insert(ckPost, at: 0)
        publicDB.save(CKRecord(ckPost)) { [weak self] (_, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error saving post record \(error) \(error.localizedDescription)")
                self.rTimer.suspend()
                self.checkAccountStatus(completion: { (isLoggedIn) in
                    completion(nil); return
                })
                completion(nil);return
            }
            self.rTimer.suspend()
            self.timerDelegate?.timerCompleted()
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
        
        let reccord = CKRecord(ckComment)
        
        publicDB.save(reccord) { (record, error) in
            if let error = error {
                print("Error saving comment to post \(error) \(error.localizedDescription)")
                completion(nil); return
            }
            DispatchQueue.main.async {
                self.delegate?.commentsWereAddedTo()
        
                completion(ckComment)
            }
        }
    }
    
    // MARK: - Fetch
    
    func fetchQueriedPosts(cursor: CKQueryOperation.Cursor? = nil, completion: @escaping (Bool, Double?) -> Void) {
        
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
        operation.desiredKeys = ["title", "timestamp"]
        operation.resultsLimit = 30
        operation.queuePriority = .high
        rTimer.eventHandler = { [weak self] in
            guard let self = self else { return }
            self.fetchCounter += 0.1
            self.timerDelegate?.increaseFetchTimer()
            print(" ⏲ Timer:  \(self.fetchCounter ??? "can't count")")
        }
        rTimer.resume()
        operation.recordFetchedBlock = { [unowned self] record in
            guard let post = CKPost(record: record) else { return }
            if let _ = self.ckPosts.index(of: post) {
                completion(false, nil); return
            }
            self.ckPosts.append(post)
            print("🎃 fetching ckPosts \(self.ckPosts.count)")
            print(self.ckPosts.count)
            completion(false, nil)
            
            DispatchQueue.main.async {
                
            }
        }
        operation.queryCompletionBlock = { [unowned self] cursor, error in
            if let error = error {
                print("Error fethcing posts \(error)")
                completion(false, nil);return 
            } else if let cursor = cursor {
                self.fetchQueriedPosts(cursor: cursor, completion: completion)
                print("Fetching more results \(self.ckPosts.count)")
            } else {
                print("Done Fetching CKPosts")
                
                self.rTimer.suspend()
                self.timerDelegate?.timerCompleted()
                self.totalCounter = self.fetchCounter
                completion(true, self.fetchCounter)
            }
        }
        publicDB.add(operation)
    }
    
    func fetchImages(cKpost: Post, completion: @escaping (UIImage?) -> Void) {
        guard let cKpost = cKpost as? CKPost else { return }
        let fetchImageOperation = CKFetchRecordsOperation(recordIDs: [cKpost.recordID])
        fetchImageOperation.recordIDs = [cKpost.recordID]
        rTimer.eventHandler = { [weak self] in
            guard let self = self else { return }
            self.fetchCounter += 0.1
            self.timerDelegate?.increaseFetchTimer()
            print(" 2⏲ Timer:  \(self.fetchCounter ??? "can't count")")
        }
        rTimer.resume()
        
        if let imageFileURL = imageCache.object(forKey: cKpost.recordID) {
            
            print("-- Getting the image from cache -- ")
            if let imageData = try? Data(contentsOf: imageFileURL as URL) {
                let image = UIImage(data: imageData)
                self.rTimer.suspend()
                self.timerDelegate?.timerCompleted()
                completion(image)
            }
        } else {
            fetchImageOperation.desiredKeys = ["imageData"]
            fetchImageOperation.queuePriority = .veryHigh
            fetchImageOperation.qualityOfService = .userInteractive
            
            fetchImageOperation.perRecordCompletionBlock = { record, recordID, error in
                if let error = error {
                    print("Error feching image completion \(error)")
                    completion(nil); return
                }
                guard let record = record,
                    let imageAsset = record.object(forKey: "imageData") as? CKAsset else {
                        completion(nil); return
                }
                if let imageData = try? Data(contentsOf: imageAsset.fileURL) {
                    let image = UIImage(data: imageData)
                    cKpost.image = image
                    self.imageCache.setObject(imageAsset.fileURL as NSURL, forKey: cKpost.recordID)
                    self.rTimer.suspend()
                    self.timerDelegate?.timerCompleted()
                    completion(image)
                }
            }
            publicDB.add(fetchImageOperation)
        }
    }
    
    func fetchComments(from post: Post, completion: @escaping ([CKComment]?, Error?) -> Void) {
        guard let ckPost = post as? CKPost else { completion(nil, nil); return }
        let postRef = ckPost.recordID
        let predicate = NSPredicate(format: "postReference == %@", postRef)
        let commentIDs = ckPost.ckComments.compactMap({$0.recordID})
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", commentIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        let query = CKQuery(recordType: "CKComment", predicate: compoundPredicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching comments from cloudKit \(#function) \(error) \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            guard let records = records else { completion(nil, nil); return }
            let ckComments = records.compactMap{CKComment(record: $0)}
            if ckComments.isEmpty {
                completion(nil, nil); return
            }
            ckPost.ckComments.append(contentsOf: ckComments)
            ckPost.ckComments = ckComments
            ckPost.comments = ckComments
            completion(ckComments, nil)
        }
    }
    
    func cancelRepeatTimer() {
        rTimer.suspend()
    }
}

