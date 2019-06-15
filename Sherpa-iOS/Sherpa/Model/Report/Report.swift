//
//  Report.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/13/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation

protocol Report {
   
    var title: String { get }
    var subTitle: String? { get }
    var reason: String { get set }
    var postID: String { get set }
    var post: Post? { get set }
    init(title: String, subTitle: String?, reason: String, postID: String)
}

struct ReportViewModel {
    var title: String
    var subTitle: String
    var post: Post?
}

