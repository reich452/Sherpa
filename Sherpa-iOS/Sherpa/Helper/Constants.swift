//
//  Constants .swift
//  Sherpa
//
//  Created by Nick Reichard on 10/27/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

struct Constants {
    
    // MARK: - Cell ID's
    static let dataBaseCell = "dataBaseCell"
    static let homeSectionHeader = "homeSectionHeader"
    static let cloudKitCell = "cloudKitCell"
    static let redditCell = "redditPostCell"
    static let commentCell = "commentCell"
    static let readOrWriteCell = "readOrWriteCell"
    static let authorCell = "authorCell"
    
    // MARK: - Storyboard Name
    static let dbActionTab = "DataBaseActionTab"
    static let firebaseTab = "FirebaseTab"
    static let feedSB = "Feed"
    static let firbaseSB = "FBPost"
    
    // MARK: - Storyboard ID's
    static let homeVC = "HomeViewController"
    static let dataBaseActionTVC = "DataBaseActionTVC"
    static let firebaseTVC = "FirebaseTableViewController"
    static let uploadVC = "UploadingViewController"
    static let feedTVC = "FeedTableViewController"
    static let fbFeedTVC = "FBPostTableViewController"
    static let rdPostTVC = "RedditTableViewController"
    static let readOrWriteTVC = "ReadOrWriteTableViewController"
    static let authorTVC = "AuthorTableViewController"
    static let movieVC = "MovieDBViewController"
    
    // MARK: - Segue
    static let toUpLoadingVC = "toUpLoadingVC"
    static let toCommentVC = "toCommentVC"
    static let toAuthorTVC = "toAuthorTVC"
}

extension Constants {
    static let dataBaseImages: [UIImage] = [#imageLiteral(resourceName: "xcCloudKit_logo"),#imageLiteral(resourceName: "xcFirebase_logo")]
    static let funApiImages: [UIImage] = [#imageLiteral(resourceName: "xcTMDB_logo"),#imageLiteral(resourceName: "xcReddit_logo")]
    static var dataBaseTVCarray = ["", "Fetching", "Uploading"]
}
