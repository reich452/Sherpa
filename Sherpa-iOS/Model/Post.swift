//
//  Post.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/27/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit
import CloudKit

protocol Post {
    var title: String { get set }
    var timestamp: Date { get set }
    var image: UIImage? { get set }
    var imageStringURL: String { get set }
}


struct CKPost: Equatable, Post {
    var imageStringURL: String = ""
    
    // MARK: - Properties
    var recordID = CKRecord.ID(recordName: UUID().uuidString)
    var title: String
    var timestamp: Date
    var photoData: Data?
    var tempURL: URL?
    var image: UIImage?{
        get{
            guard let photoData = photoData else {return nil}
            return UIImage(data: photoData)
        }
        set{
            photoData = newValue?.jpegData(compressionQuality: 0.6)
        }
    }
    
    var imageAsset: CKAsset? {
        mutating get {
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
    
    init(title: String, timestamp: Date = Date(), image: UIImage) {
        self.title = title
        self.timestamp = timestamp
        self.image = image
    }
    
    // MARK: - Fetching
    init?(record: CKRecord) {
        guard let title = record[Constants.titleKey] as? String,
            let timestamp = record.creationDate,
            let imageAsset = record[Constants.imageDataKey] as? CKAsset else { return nil }
        guard let photoData = try? Data(contentsOf: imageAsset.fileURL) else { return nil }
        
        self.title = title
        self.timestamp = timestamp
        self.photoData = photoData
        self.recordID = record.recordID
    }
    
}

extension CKRecord {
    convenience init(_ ckPost: CKPost) {
        var ckPost = ckPost
        let recordID = ckPost.recordID
        self.init(recordType: CKPost.Constants.ckPostKey, recordID: recordID)
        self.setValue(ckPost.title, forKey: CKPost.Constants.titleKey)
        self.setValue(ckPost.timestamp, forKey: CKPost.Constants.timestampKey)
        self.setValue(ckPost.imageAsset, forKey: CKPost.Constants.imageDataKey)
        
    }
}
