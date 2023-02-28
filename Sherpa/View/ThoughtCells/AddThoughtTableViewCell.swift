//
//  AddThoughtTableViewCell.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/23/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

class AddThoughtTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var underLineBtn: CustomButton!
    @IBOutlet private weak var addButton: CustomButton!
    @IBOutlet private weak var bottomButton: CustomButton!
    
    func updateViews(selectedDB: SelectedIconDB) {
        contentView.backgroundColor = .primaryColor
        if selectedDB == .cloudKit {
            
        } else {
            titleLabel.text = "Add Thought On Firebase"
            let infoText = infoLabel.text?.replacingOccurrences(of: "CloudKit", with: "Firebase")
            infoLabel.text = infoText ?? ""
            addButton.topGradiant = .firebaseDarkOrange
            addButton.bottomGradiant = .firebaseYellow
            underLineBtn.topGradiant = .firebaseDarkOrange
            underLineBtn.bottomGradiant = .yellow
            bottomButton.topGradiant = .firebaseDarkOrange
            bottomButton.bottomGradiant = .yellow
        }
    }
    
    // MARK: - Actions 
    
    @IBAction private func addButtonTapped(_ sender: CustomButton) {
        // no op. 
    }
}
