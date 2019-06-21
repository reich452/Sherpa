//
//  FBPostTableViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit
import Firebase
// TODO: - Take out and make reusable with feedTVC

class FBPostTableViewController: UITableViewController, ActivityIndicatorPresenter {
    
    // MARK: - Properties
    var activityIndicator = UIActivityIndicatorView()
    private lazy var fbPostController: FireBasePostController = {
        let storageRef = StorageReference()
        let storageManager = StorageManager(storageRef: storageRef)
        return FireBasePostController(storageManager: storageManager)
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
        fbPostController.timerDelegate = self
        fbPostController.myTimer.delegate = self
        self.showActivityIndicator()
        reloadFbPosts()

    }
    
    // MARK: - Actions
    func reloadFbPosts() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        fbPostController.fetchPosts { [weak self] (_, error) in
            guard let self = self else { return }
            if error == nil {
                self.tableView.reloadData()
                self.hideActivityIndicator()
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fbPostController.fbPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FBPostCell", for: indexPath) as? FBFeedTableViewCell else { return UITableViewCell() }
        
        let fbPost = fbPostController.fbPosts[indexPath.row]
        cell.post = fbPost
        cell.delegate = self
        if fbPost.image == nil {
            fbPostController.fetchImage(post: fbPost) { (image) in
                DispatchQueue.main.async {
                    if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath == indexPath {
                        UIView.transition(with: cell.contentView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                            cell.photoImageView.image = image
                        }, completion: nil)
                        cell.activityIndicator.stopAnimating()
                        cell.contentView.sendSubviewToBack(cell.activityIndicator)
                    } else { return }
                }
            }
        }
        return cell
    }
    

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCommentsVC" {
            guard let destinationVC = segue.destination as? CommentListTableViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            let fbPost = fbPostController.fbPosts[indexPath.row]
            destinationVC.post = fbPost
            destinationVC.fbCommentController = FBCommnetController()
        }
    }
}
// MARK: - FetchAndUploadCounter Delegate

extension FBPostTableViewController: FetchAndUploadCounter, MyTimerDelegate {
    
    func updateTimeLable(counterStr: String) {
        self.navigationItem.title = "Fetching Time: \(counterStr)"
    }
    
    func timerCompleted() {
        self.fbPostController.myTimer.stopTimer()
    }
    
}

extension FBPostTableViewController: FBFeedTableViewCellDelegate {
  
    func didTapReportButton(_ cell: FBFeedTableViewCell) {
        let sb = UIStoryboard(name: "ReportAbuse", bundle: nil)
        guard let reportVC = sb.instantiateViewController(withIdentifier: Constants.reportTVC) as? ReportTableViewController else { return }
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let fbPost = fbPostController.fbPosts[indexPath.row]
        reportVC.post = fbPost
        navigationController?.pushViewController(reportVC, animated: true)
    }
    
}
