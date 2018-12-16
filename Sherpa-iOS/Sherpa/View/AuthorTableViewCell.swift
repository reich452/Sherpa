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
    @IBOutlet weak var proTextLabel: UILabel!
    @IBOutlet weak var conTextLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var opinionLabel: UILabel!
    
    
    var author: Author? {
        didSet {
            guard let author = author else { return }
            updateViews(author: author)
            checkRating(author: author)
        }
    }
    
    func updateViews(author: Author) {
        proTextLabel.text = author.pro
        conTextLabel.text = author.con
        detailLabel.text = author.detail
        opinionLabel.text = author.opinion
    }
    
    func checkRating(author: Author) {
        switch author.rating {
        case 0:
            ratingLabel.text = "Rating 0"
        case 1:
            ratingLabel.text = "Rating  ⭐️"
        case 2:
            ratingLabel.text = "Rating  ⭐️⭐️"
        case 3:
            ratingLabel.text = "Rating  ⭐️⭐️⭐️"
        case 4:
            ratingLabel.text = "Rating  ⭐️⭐️⭐️⭐️"
        case 5:
            ratingLabel.text = "Rating  ⭐️⭐️⭐️⭐️⭐️"
        default:
            ratingLabel.text = "Rating \(author.rating)"
        }
    }
}
