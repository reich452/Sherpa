//
//  FeedTableViewCell.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit
import Firebase

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commnetLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    

    var post: Post? {
        didSet {
            updateViews()
        }
    }
 
    func updateViews() {
        guard let post = post else { return }
        titleLabel.text = post.title
        photoImageView.image = post.image
        
    }
    
}
