//
//  FbPost.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import Foundation
import Firebase

struct FbPost: Post {
    
    var comments: [Comment] = []
    var dataBase: DataBase = .firebase
    
    enum Constans {
        static let titleKey = "title"
        static let timestampKey = "timestamp"
        static let imageStringURL = "image"
    }
    
    // MARK: - Properties
    var title: String
    var timestamp: Date = Date()
    var image: UIImage?
    var imageStringURL: String
    var timeInt: Int
    
    init(title: String, imageStringURL: String, timeInt: Int = Int(NSDate().timeIntervalSince1970 * 1000)) {
        self.title = title
        self.imageStringURL = imageStringURL
        self.timeInt = timeInt
    }
    
    // MARK: - Dictionary
    
    var dictionaryRep: [String: Any] {
        return [
            Constans.titleKey : self.title,
            Constans.imageStringURL : self.imageStringURL,
            Constans.timestampKey : self.timeInt
        ]
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dictionary = snapshot.value as? [String: Any] else { return nil }
        guard let title = dictionary[Constans.titleKey] as? String,
            let imageStringUrl = dictionary[Constans.imageStringURL] as? String,
            let timeInt = dictionary[Constans.timestampKey] as? Int else { return nil }
        
        self.init(title: title, imageStringURL: imageStringUrl, timeInt: timeInt)
    }
    
}

// MARK: - Search 

extension FbPost {
    func matches(searchTerm: String) -> Bool {
        if title.lowercased().contains(searchTerm.lowercased()){
            return true
        }
        return false
    }
}
