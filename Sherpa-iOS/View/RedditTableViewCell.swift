//
//  RedditTableViewCell.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/30/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

class RedditTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postThumbnail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    
    var rdPost: RDPost? {
        didSet {
            updateViews()
        }
    }
    
    var thumbnail: UIImage? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Functions
    
    func updateViews() {
        guard let rdPost = rdPost else { return }
        titleLabel.text = rdPost.title
        if let thumbnail = thumbnail {
            postThumbnail.image = thumbnail
        } else {
            postThumbnail.image = #imageLiteral(resourceName: "xcReddit_logo")
        }
    }

}
