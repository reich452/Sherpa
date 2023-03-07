//
//  StorageManager.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/30/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

final class StorageManager {
    
    var storageRef: StorageReference
    
    init(storageRef: StorageReference) {
        self.storageRef = storageRef
    }
    
    enum ContentType: String {
        case imageJpeg = "image/jpeg"
        case png = "png"
        case pdf = "pdf"
    }
    
    func uploadData(_ data: Data, named filename: String, file node: String, contentType: ContentType, completion: @escaping (URL?, Error?) -> Void) {
        let ref = self.storageRef.child(filename).child(node)
        let metatdata = StorageMetadata()
        metatdata.contentType = contentType.rawValue
        
        ref.putData(data, metadata: metatdata) { (metadata, error) in
            if let error = error {
                debugPrint("Error with putData: \(#function) \(error)")
                completion(nil, error)
                return
            }
            guard let metadata = metadata,
                let path = metadata.path else {
                    completion(nil, NSError(domain: "core", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unexpected error Path is nil"]))
                    return
            }
            self.getDownloadedURL(from: path, completion: completion)
        }
    }
    
    func uploadURL(_ url: URL, named filename: String, file node: String, completion: @escaping (URL?, Error?) -> Void) {
        let ref = self.storageRef.child(filename).child(node)
        ref.putFile(from: url, metadata: nil) { (metadata, error) in
            guard let metadata = metadata,
                let path = metadata.path else {
                    completion(nil, NSError(domain: "core", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unexpected error Path is nil"]))
                    return
            }
            self.storageRef.child(path).downloadURL(completion: completion)
        }
    }
    
    // MARK: - Private
    
    private func getDownloadedURL(from path: String, completion: @escaping (URL?, Error?) -> Void) {
        self.storageRef.child(path).downloadURL(completion: completion)
    }
}
