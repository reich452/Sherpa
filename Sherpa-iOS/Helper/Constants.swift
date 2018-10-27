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
    
    // MARK: - Storyboard Name
    static let cloudKitTab = "CloudKitTab"
    static let firebaseTab = "FirebaseTab"
    
    // MARK: - Storyboard ID's
    static let homeVC = "HomeViewController"
    static let cloudKitTVC = "CloudKitTableViewController"
    static let firebaseTVC = "FirebaseTableViewController"
}

extension Constants {
    static let dataBaseImages: [UIImage] = [#imageLiteral(resourceName: "xcCloudKit_logo"),#imageLiteral(resourceName: "xcFirebase_logo")]
    static let funApiImages: [UIImage] = [#imageLiteral(resourceName: "xcTMDB_logo"),#imageLiteral(resourceName: "xcReddit_logo")]
}
