//
//  ReadOrWriteTableViewCell.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/21/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

protocol LatestNewsTableViewCellDelegate: class {
    func didTapPlayButton(_ cell: LatestNewsTableViewCell)
}

class LatestNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playViewBackground: UIView!
    @IBOutlet weak var overlayPlayBtn: UIButton!
    
    weak var delegate: LatestNewsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        playViewBackground.makeRoundView()
        headerImage.roundCornersForAspectFit(radius: 8)
    }

    @IBAction func playBtnTapped(_ sender: Any) {
        delegate?.didTapPlayButton(self)
    }
    

}
