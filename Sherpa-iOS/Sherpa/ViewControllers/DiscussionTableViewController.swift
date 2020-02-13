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
    public var cKDiscussionController: CKDiscussionController?
    public var fbDiscussionController: FBDiscussionController?
    
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
        title = "Discussion"
        tableView.backgroundColor = .primaryColor
        fetchCKThoughts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func fetchCKThoughts() {
        
        if selectedDB == .cloudKit {
            // TODO: - Comments for a thought
            cKDiscussionController?.fetchThoughts { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let ckThoughts):
                    guard let ckThoughts = ckThoughts else { return }
                    self.thoughs = ckThoughts
                    DispatchQueue.main.async {
                        self.tableView.reloadSections(IndexSet(integer: 3), with: .fade)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showNoActionAlert(titleStr: "Error Fetching CKThoughts", messageStr: error.localizedDescription, style: .cancel)
                    }
                }
            }
        } else {
            fbDiscussionController?.fetchFBThoughts(completion: { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let fbThought):
                    guard let fbThought = fbThought, !fbThought.isEmpty else { return }
                    self.thoughs = fbThought
                    self.tableView.reloadSections(IndexSet(integersIn: 3...3), with: .fade)
                case .failure(let error):
                    self.showNoActionAlert(titleStr: "Error Fetching Firebase Thoughts", messageStr: error.localizedDescription, style: .cancel)
                }
            })
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
            cell.updateViews(selectedDB: selectedDB)
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.addThoughtCell, for: indexPath) as? AddThoughtTableViewCell else { return UITableViewCell() }
            cell.updateViews(selectedDB: selectedDB)
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
            shareThoughtVC.selectedDB = self.selectedDB
            shareThoughtVC.delegate = self
            if selectedDB == .cloudKit {
                shareThoughtVC.ckDiscussionController = CKDiscussionController()
            } else {
                shareThoughtVC.fbDiscussionController = FBDiscussionController()
            }
        }
    }
}

extension DiscussionTableViewController: LatestNewsTableViewCellDelegate {
    func didTapPlayButton(_ cell: LatestNewsTableViewCell) {
        let player = AVPlayer(url: URL(string: Constants.cloudKitVideo)!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        
        present(playerController, animated: true) {
            player.play()
        }
    }
}

extension DiscussionTableViewController: ShareThoughtViewControllerDelegate {
    func reloadThoughts(_ thought: Thought) {
        self.thoughs.insert(thought, at: 0)
        self.tableView.reloadSections(IndexSet(integersIn: 3...3), with: .fade)
    }
}

