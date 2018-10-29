//
//  FeedTableViewCell.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commnetLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    var ckPost: CKPost? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let ckPost = ckPost else { return }
        titleLabel.text = ckPost.title
        photoImageView.image = ckPost.image
    }

}
