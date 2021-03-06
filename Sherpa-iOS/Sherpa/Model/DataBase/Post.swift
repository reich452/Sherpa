//
//  Post.swift
//  Sherpa
//
//  Created by Nick Reichard on 11/9/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

enum DataBase {
    case cloudKit
    case firebase
}

protocol Post {
    var title: String { get set }
    var timestamp: Date { get set }
    var image: UIImage? { get set }
    var imageStringURL: String { get set }
    var comments: [Comment] { get set }
    var dataBase: DataBase { get set }
    var postID: String { get set }
    func matches(searchTerm: String) -> Bool
}
