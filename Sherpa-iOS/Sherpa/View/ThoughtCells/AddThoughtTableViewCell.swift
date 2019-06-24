//
//  AddThoughtTableViewCell.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/23/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

class AddThoughtTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var underLineBtn: CustomButton!
    @IBOutlet weak var addButton: CustomButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBAction func addButtonTapped(_ sender: CustomButton) {
    }
    
}
