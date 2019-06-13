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
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2.5)
        self.addSubview(activityIndicator)
        return activityIndicator
    }()

    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(activityIndicator)
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
        photoImageView.image = #imageLiteral(resourceName: "xceCloudLoad")
        commnetLabel.text = "Comments \(post.comments.count)"

        activityIndicator.startAnimating()
        CloudKitPostController.shared.fetchImages(cKpost: post) { (image) in
            DispatchQueue.main.async {
                self.photoImageView.image = image
                self.activityIndicator.stopAnimating()
                self.contentView.sendSubviewToBack(self.activityIndicator)
            }
        }
        CloudKitPostController.shared.fetchComments(from: post) { (comments) in
            if comments != nil {
                DispatchQueue.main.async {
                    self.commnetLabel.text = "Comments \(comments?.count ??? "")"
                }
            } else {
                DispatchQueue.main.async {
                    self.commnetLabel.text = "0 Comments"
                }
            }
        }
    }
}
