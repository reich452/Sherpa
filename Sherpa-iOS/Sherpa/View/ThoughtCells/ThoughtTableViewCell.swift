//
//  ThoughtTableViewCell.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/23/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

class ThoughtTableViewCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var thoughtText: UILabel!
    
    private let dateFormatter = DateFormatter.yearMonthDayFormat
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .primaryColor
    }
    
    var thought: Thought? {
        didSet {
            updateViews()
        }
    }
    
    // TODO: - Better UI
    private func updateViews() {
        guard let thought = thought else { return }
        
        nameLabel.text = thought.author
        thoughtText.text = "\(thought.title) \n\n\(thought.body)"
        if thought.database == .cloudKit {
            dateLabel.text = dateFormatter.string(from: thought.timestamp)
        } else {
            guard let fbThought = thought as? FBThought else { return }
            let date = Date(timeIntervalSince1970: TimeInterval(fbThought.timeInt/1000))
            dateLabel.text = dateFormatter.string(from: date)
        }
    }
}
