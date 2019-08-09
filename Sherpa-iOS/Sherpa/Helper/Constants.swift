//
//  Constants .swift
//  Sherpa
//
//  Created by Nick Reichard on 10/27/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

struct Constants {
    
    static let cloudKitVideo = "https://devstreaming-cdn.apple.com/videos/wwdc/2019/202mm1h4jl4wiz1h3/202/202_sd_using_core_data_with_cloudkit.mp4?dl=1"
    // MARK: - Cell ID's
    static let dataBaseCell = "dataBaseCell"
    static let homeSectionHeader = "homeSectionHeader"
    static let cloudKitCell = "cloudKitCell"
    static let redditCell = "redditPostCell"
    static let commentCell = "commentCell"
    static let latestNewsCell = "latestNewsCellId"
    static let authorCell = "authorCell"
    static let addThoughtCell = "addThoughtCellId"
    static let thoughtSectionCell = "thoughtSectionCell"
    static let thoughtCell = "thoughtCellId"
    
    // MARK: - Storyboard Name
    static let dbActionTab = "DataBaseActionTab"
    static let firebaseTab = "FirebaseTab"
    static let feedSB = "Feed"
    static let firbaseSB = "FBPost"
    static let reportAbuse = "ReportAbuse"
    
    // MARK: - Storyboard ID's
    static let homeVC = "HomeViewController"
    static let dataBaseActionTVC = "DataBaseActionTVC"
    static let firebaseTVC = "FirebaseTableViewController"
    static let uploadVC = "UploadingViewController"
    static let feedTVC = "FeedTableViewController"
    static let fbFeedTVC = "FBPostTableViewController"
    static let rdPostTVC = "RedditTableViewController"
    static let discussionTVC = "DiscussionTableViewController"
    static let authorTVC = "AuthorTableViewController"
    static let movieVC = "MovieDBViewController"
    static let reportTVC = "ReportTableViewController"
    
    // MARK: - Segue
    static let toUpLoadingVC = "toUpLoadingVC"
    static let toCommentVC = "toCommentVC"
    static let toAuthorTVC = "toAuthorTVC"
    static let toAddThoughtVC = "toAddThought"
    
    // MARK: - UserDefaultKeys 
    static let hasSeenOnboarding = "hasSeenOnboarding"
    
    struct Query {
        
        static fileprivate let API_KEY: String = "fb333a11ee907b2868d5e2141a2c0222"
        static let searchBase_url = "https://api.themoviedb.org/3/search/movie?api_key=" + API_KEY
        static let trendingBase_url = "https://api.themoviedb.org/3/trending/all/day?api_key=" + API_KEY
        static let query_param = "&query="
        static let page_parm = "&page=1"
        static let include_alult_parm = "&include_adult=true"
        static let image_base_url = "https://image.tmdb.org/t/p/w500"
    }

}

extension Constants {
    static let dataBaseImages: [UIImage] = [#imageLiteral(resourceName: "xcCloudKit_logo"),#imageLiteral(resourceName: "xcFirebase_logo")]
    static let funApiImages: [UIImage] = [#imageLiteral(resourceName: "xcTMDB_logo"),#imageLiteral(resourceName: "xceLiveVotes")]
    static var dataBaseTVCarray = ["", "Fetching", "Uploading"]
}
