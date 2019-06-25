//
//  ReadOrWriteTableViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 11/14/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit
import AVKit

class DiscussionTableViewController: UITableViewController {
    
    // MARK: - Properties
    public var selectedDB: SelectedIconDB!
    public var cKDiscussionController: CKDiscussionController!

    private var thoughs: [Thought] = []
    private enum DisscussionSections: CaseIterable {
        case news
        case add
        case discussionHeader
        case discussion
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCKThoughts()
    }

    private func fetchCKThoughts() {
        
        if selectedDB == .cloudKit {
            // TODO: - Comments for a thought
        } else {
            // TODO: - Firebase
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        cKDiscussionController.fetchThoughts { (result) in
            switch result {
            case .success(let ckThoughts):
                guard let ckThoughts = ckThoughts else { return }
               self.thoughs = ckThoughts
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showNoActionAlert(titleStr: "Error Fetching CKThoughts", messageStr: error.localizedDescription, style: .cancel)
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return DisscussionSections.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return thoughs.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.latestNewsCell, for: indexPath) as? LatestNewsTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.addThoughtCell, for: indexPath) as? AddThoughtTableViewCell else { return UITableViewCell() }
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.thoughtSectionCell, for: indexPath)
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.thoughtCell, for: indexPath) as? ThoughtTableViewCell else { return UITableViewCell() }
            let thought = self.thoughs[indexPath.row]
            cell.thought = thought
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        if segue.identifier == Constants.toAddThoughtVC {
            guard let shareThoughtVC = segue.destination as? ShareThoughtViewController else { return }
            shareThoughtVC.ckDiscussionController = CKDiscussionController()
        }
    }
}

extension DiscussionTableViewController: LatestNewsTableViewCellDelegate {
    func didTapPlayButton(_ cell: LatestNewsTableViewCell) {
        let urlString = "https://devstreaming-cdn.apple.com/videos/wwdc/2019/202mm1h4jl4wiz1h3/202/202_sd_using_core_data_with_cloudkit.mp4?dl=1"
        
        let url = URL(string: urlString)
        let player = AVPlayer(url: url!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    // TODO: - Video and UI for Firebase 
}

extension DiscussionTableViewController {
    
    // MARK: - UI
   fileprivate func setUpUI() {
        title = "Discussion"
        tableView.separatorStyle = .none
    }
}
