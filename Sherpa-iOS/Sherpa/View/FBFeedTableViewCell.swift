//
//  FBFeedTableViewCell.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/15/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

protocol FBFeedTableViewCellDelegate: class {
    func didTapReportButton(_ cell: FBFeedTableViewCell)
}
// TODO: - Make this a nib for one cell 
class FBFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2.5)
        self.addSubview(activityIndicator)
        return activityIndicator
    }()
    
    weak var delegate: FBFeedTableViewCellDelegate?  
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateViews() {
        guard let post = post else { return }
        titleLabel.text = post.title
        if let fbPost = post as? FBPost {
            let date = Date(timeIntervalSince1970: TimeInterval(fbPost.timeInt/1000))
            timestampLabel.text = " \(DateHelper.shared.dateToString(date: date))"
        }
    }
   
    // MARK: - Actions
    @IBAction func reportBtnTapped(_ sender: Any) {
        if let delegate = delegate {
            delegate.didTapReportButton(self)
        }
    }
}
