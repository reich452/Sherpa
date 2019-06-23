//
//  ReadOrWriteTableViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 11/14/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit
import AVKit

class ReadOrWriteTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    var dataBaseString = ""
    let options = ["Author", "Comments"]
    let cellSpacing: CGFloat = 10
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.readOrWriteCell, for: indexPath) as? ReadOrWriteTableViewCell else { return UITableViewCell() }
       cell.delegate = self
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        if segue.identifier == Constants.toAuthorTVC {
            guard let destinationVC = segue.destination as? AuthorTableViewController else { return }
            destinationVC.dataBaseString = dataBaseString
        }
    }
}

extension ReadOrWriteTableViewController: ReadOrWriteTavleViewCellDelegate {
    func didTapPlayButton(_ cell: ReadOrWriteTableViewCell) {
        let urlString = "https://devstreaming-cdn.apple.com/videos/wwdc/2019/202mm1h4jl4wiz1h3/202/202_sd_using_core_data_with_cloudkit.mp4?dl=1"
        
        let url = URL(string: urlString)
        let player = AVPlayer(url: url!)
        
        let playerController = AVPlayerViewController()
        playerController.player = player
        
        present(playerController, animated: true) {
            player.play()
        }
    }
}

extension ReadOrWriteTableViewController {
    
    // MARK: - UI
    func setUpUI() {
        title = "Discussion"
        tableView.separatorStyle = .none
        tableView.backgroundColor = .primaryColor
    }
}
