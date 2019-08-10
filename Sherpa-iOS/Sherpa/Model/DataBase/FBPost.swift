//
//  FbPost.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import Foundation
import Firebase

class FBPost: Post {
    
    var comments: [Comment] = []
    var dataBase: DataBase = .firebase
    var postID: String
    enum Constans {
        static let titleKey = "title"
        static let timestampKey = "timestamp"
        static let imageStringURL = "image"
        static let uuidKey = "uuid"
    }
    
    // MARK: - Properties
    var uuid: String
    var title: String
    var timestamp: Date = Date()
    var image: UIImage?
    var imageStringURL: String
    var timeInt: Int

    
    init(title: String, imageStringURL: String, timeInt: Int = Int(NSDate().timeIntervalSince1970 * 1000), uuid: String) {
        self.title = title
        self.imageStringURL = imageStringURL
        self.timeInt = timeInt
        self.uuid = uuid
        self.postID = uuid
    }
    
    // MARK: - Dictionary
    
    var dictionaryRep: [String: Any] {
        return [
            Constans.titleKey : self.title,
            Constans.imageStringURL : self.imageStringURL,
            Constans.timestampKey : self.timeInt,
            Constans.uuidKey : self.uuid
        ]
    }
    
    convenience init?(snapshot: DataSnapshot) {
        guard let dictionary = snapshot.value as? [String: Any] else { return nil }
        guard let title = dictionary[Constans.titleKey] as? String,
            let imageStringUrl = dictionary[Constans.imageStringURL] as? String,
            let timeInt = dictionary[Constans.timestampKey] as? Int,
            let uuid = dictionary[Constans.uuidKey] as? String else { return nil}
        self.init(title: title, imageStringURL: imageStringUrl, timeInt: timeInt, uuid: uuid)
        self.postID = uuid
    }
}


// MARK: - Search 

extension FBPost {
    func matches(searchTerm: String) -> Bool {
        if title.lowercased().contains(searchTerm.lowercased()){
            return true
        }
        return false
    }
}
