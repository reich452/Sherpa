//
//  RdPost.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/30/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import Foundation
struct JsonDictionary: Decodable {
    
    let data: DataDictionary
}

struct DataDictionary: Decodable {
    
    let children: [PostDictionary]
    let after: String?
    
    struct PostDictionary: Decodable {
        let data: RDPost
    }
}
// TODO: - make Post Protocol work with Codable
struct RDPost: Decodable {
    
    let title: String?
    let thumbnail: String?
    let permalink: String?
}
