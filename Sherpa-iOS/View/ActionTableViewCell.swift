//
//  ActionTableViewCell.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/27/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

protocol ActionTableViewCellDelegate: class {
    func hideSelectedObjects(sender: ActionTableViewCell)
}

class ActionTableViewCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var secondIconImageView: UIImageView!
    
    weak var delegate: ActionTableViewCellDelegate?
    
    var selectedDB: SelectedIconDB? {
        didSet {
            delegate?.hideSelectedObjects(sender: self)
            guard let selectedDB = selectedDB else { return }
            self.selectedTab(slectedIcon: selectedDB)
        }
    }

    func selectedTab(slectedIcon: SelectedIconDB) {
        switch slectedIcon {
        case .cloudKit:
            self.iconImageView.image = #imageLiteral(resourceName: "xcCloudKit_logo")
            self.actionLabel.textColor = UIColor.cloudKitLightBlue
        case .firebase:
            self.iconImageView.image = #imageLiteral(resourceName: "xcFirebase_logo")
            self.actionLabel.textColor = UIColor.firebaseDarkOrange
     
        }
    }

}
