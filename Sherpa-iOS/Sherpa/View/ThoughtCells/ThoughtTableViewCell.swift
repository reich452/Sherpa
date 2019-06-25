//
//  ThoughtTableViewCell.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/23/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

class ThoughtTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thoughtText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var thought: Thought? {
        didSet {
            updateViews()
        }
    }
    
    // TODO: - Better UI 
    func updateViews() {
        guard let thought = thought else { return }
        
        nameLabel.text = thought.author
        
        thoughtText.text = thought.body
        dateLabel.text = DateHelper.shared.dateToString(date: thought.timestamp)
    }
 
}
