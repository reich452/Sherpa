//
//  Post.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/27/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit
import CloudKit

class CKPost: Post {


    var dataBase: DataBase = .cloudKit
    /// Not used for in cloudKit. Leave empty 
    var imageStringURL: String = ""
    
    // MARK: - Properties
    var recordID = CKRecord.ID(recordName: UUID().uuidString)
    var title: String
    var timestamp: Date
    var photoData: Data?
    var tempURL: URL?
    var comments: [Comment] = []
    var ckComments: [CKComment] = []
    var postID: String
    var image: UIImage?{
        get{
            guard let photoData = photoData else {return nil}
            return UIImage(data: photoData)
        }
        set{
            photoData = newValue?.jpegData(compressionQuality: 0.2)
        }
    }
    
    var imageAsset: CKAsset? {
         get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirecotryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirecotryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            self.tempURL = fileURL
            do {
                try photoData?.write(to: fileURL)
            } catch let error {
                print("Error writing to temp url \(error) \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    // MARK: - Constants
    enum Constants {
        static let ckPostKey = "CKPost"
        static let titleKey = "title"
        static let imageDataKey = "imageData"
        static let ckRecordIdKey = "ckRecordId"
        static let timestampKey = "timestamp"
    }
    
    // MARK: - Initialization
    
    init(title: String, timestamp: Date = Date(), image: UIImage, ckComments: [CKComment] = []) {
        self.title = title
        self.timestamp = timestamp
        self.postID = recordID.recordName
        self.image = image
        self.ckComments = ckComments
    }
    
    // MARK: - Fetching
    init?(record: CKRecord) {
        guard let title = record[Constants.titleKey] as? String,
            let timestamp = record.creationDate else { return nil }
        
        let imageAsset = record[Constants.imageDataKey] as? CKAsset ?? nil
        if let imageFileURL = imageAsset?.fileURL {
            self.photoData = try! Data(contentsOf: imageFileURL) 
        }
        self.title = title
        self.timestamp = timestamp
        self.ckComments = []
        self.recordID = record.recordID
        self.postID = record.recordID.recordName
    }
}

extension CKRecord {
    convenience init(_ ckPost: CKPost) {
//        var ckPost = ckPost
        let recordID = ckPost.recordID
        self.init(recordType: CKPost.Constants.ckPostKey, recordID: recordID)
        self.setValue(ckPost.title, forKey: CKPost.Constants.titleKey)
        self.setValue(ckPost.timestamp, forKey: CKPost.Constants.timestampKey)
        self.setValue(ckPost.imageAsset, forKey: CKPost.Constants.imageDataKey)
        
    }
}
extension CKPost: Equatable {
    static func == (lhs: CKPost, rhs: CKPost) -> Bool {
        if lhs.title != rhs.title { return false }
        if lhs.recordID != rhs.recordID { return false }
        if lhs.title != rhs.title { return false }
        if lhs.timestamp != rhs.timestamp { return false }
        return true
    }
    
    
}
extension CKPost {
    
    func matches(searchTerm: String) -> Bool {
        if title.lowercased().contains(searchTerm.lowercased()){
            return true
        }
        return false
    }
}
