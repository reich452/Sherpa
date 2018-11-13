//
//  FeedTableViewCell.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit
import Firebase

protocol FeedTableViewCellDelegate: class {
    func didTapCommentButton(_ cell: FeedTableViewCell)
}

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commnetLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    

    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: FeedTableViewCellDelegate?  
 
    @IBAction func didTapCommentButton(_ sender: Any) {
        if let delegate = delegate {
            delegate.didTapCommentButton(self)
        }
    }
    func updateViews() {
        guard let post = post else { return }
        titleLabel.text = post.title
        photoImageView.image = post.image
        commnetLabel.text = "Comments \(post.comments.count)"
        CloudKitPostController.shared.fetchComments(from: post) { (comments) in
            if comments != nil {
                DispatchQueue.main.async {
                    self.commnetLabel.text = "Comments \(comments?.count ??? "")"
                }
            } else {
                self.commnetLabel.text = "0 Comments"
            }
        }
    }
        
    
    
}
