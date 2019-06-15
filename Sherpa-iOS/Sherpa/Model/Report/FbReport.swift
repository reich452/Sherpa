//
//  FbReport.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/14/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import Foundation

struct FbReport: Report {

    var title: String
    var subTitle: String?
    var reason: String
    var postID: String
    var post: Post?

    init(title: String, subTitle: String?, reason: String, postID: String) {
        self.title = title
        self.subTitle = subTitle
        self.reason = reason
        self.postID = postID

    }
}
