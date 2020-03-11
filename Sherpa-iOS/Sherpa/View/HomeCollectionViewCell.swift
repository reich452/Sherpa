//
//  HomeCollectionViewCell.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/27/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

protocol HomeCollectionViewCellDelegate: class {
    func didTapCellButton(cell: HomeCollectionViewCell)
}

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backContainerView: UIView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var cellButton: UIButton!
    
    weak var delegate: HomeCollectionViewCellDelegate?
    
    // MARK: - Actions
    
    @IBAction func didTapCellButton(_ sender: UIButton) {
        delegate?.didTapCellButton(cell: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backContainerView.clipsToBounds = true
        topContainerView.clipsToBounds = true
        logoImageView.clipsToBounds = true
    }
}
