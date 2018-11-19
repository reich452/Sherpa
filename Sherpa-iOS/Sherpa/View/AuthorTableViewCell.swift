//
//  AuthorTableViewCell.swift
//  Sherpa
//
//  Created by Nick Reichard on 11/17/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

class AuthorTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var proLabel: UILabel!
    @IBOutlet weak var proTextLabel: UILabel!
    @IBOutlet weak var conLabel: UILabel!
    @IBOutlet weak var conTextLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingTextLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailInfoLabel: UILabel!
    @IBOutlet weak var opinionLabel: UILabel!
    @IBOutlet weak var opinionTextLabel: UILabel!
    
    var author: AuthorModel? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let aurthor = author else { return }
        proTextLabel.text = aurthor.pro
        conTextLabel.text = aurthor.con
        ratingLabel.text = "\(aurthor.rating)"
        detailLabel.text = aurthor.detail
        opinionLabel.text = aurthor.opinion
    }
    
}
