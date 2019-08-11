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
    func didTapReportButton(_ cell: FeedTableViewCell)
}
// TODO: - Make this a nib for one cell 
class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commnetLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
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
    
    @IBAction func didTapReportButton(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapReportButton(self)
        }
    }
    func updateViews() {
        contentView.backgroundColor = .primaryColor
        guard let post = post else { return }
        switch post.dataBase {
        case .cloudKit:
            titleLabel.text = post.title
            photoImageView.image = #imageLiteral(resourceName: "xceCloudLoad")
            commnetLabel.text = "Comments..."
            dateLabel.text = "\(DateHelper.shared.dateToString(date: post.timestamp)) ago"
            activityIndicator.startAnimating()
            CloudKitPostController.shared.fetchImages(cKpost: post) { (image) in
                DispatchQueue.main.async {
                    UIView.transition(with: self.contentView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                        self.photoImageView.image = image
                    }, completion: nil)
                    self.photoImageView.image = image
                    self.activityIndicator.stopAnimating()
                    self.contentView.sendSubviewToBack(self.activityIndicator)
                }
            }
        case .firebase:
            titleLabel.text = post.title
            if let fbPost = post as? FBPost {
                let date = Date(timeIntervalSince1970: TimeInterval(fbPost.timeInt/1000))
                dateLabel.text = " \(DateHelper.shared.dateToString(date: date))"
            }
        }
    }
}
