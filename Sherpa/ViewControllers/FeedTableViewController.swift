//
//  FeedTableViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit
import Firebase

class FeedTableViewController: UITableViewController, FeedTableViewCellDelegate, DidPassUpdatedComments, FetchAndUploadCounter  {
    
    var selectedDB: SelectedIconDB = .cloudKit
    private lazy var fbPostController: FireBasePostController = {
        let storageRef = StorageReference()
        let storageManager = StorageManager(storageRef: storageRef)
        return FireBasePostController(storageManager: storageManager)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CloudKitPostController.shared.timerDelegate = self
        fbPostController.timerDelegate = self
        fbPostController.myTimer.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        switch selectedDB {
        case .cloudKit:
            CloudKitPostController.shared.fetchQueriedPosts { (didFinish, counter) in
                if didFinish != false {
                    DispatchQueue.main.async {
                        self.tableView.separatorStyle = .singleLine
                        self.tableView.reloadData()
                    }
                }
            }
        case .firebase:
            fbPostController.fetchPosts { [weak self] (_, error) in
                guard let self = self else { return }
                if error == nil {
                    self.tableView.separatorStyle = .singleLine
                    self.tableView.reloadData()
                } else {
                    self.showNoActionAlert(titleStr: "Error Fetching Firebase Posts", messageStr: error?.localizedDescription ?? "Please try again", style: .cancel)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CloudKitPostController.shared.cancelRepeatTimer()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDB == .cloudKit ? CloudKitPostController.shared.ckPosts.count : fbPostController.fbPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as? FeedTableViewCell else { return UITableViewCell() }
        
        switch selectedDB {
        case .cloudKit:
            let dataSource = CloudKitPostController.shared.ckPosts
            let ckPost = dataSource[indexPath.row]
            cell.delegate = self
            cell.photoImageView.image = #imageLiteral(resourceName: "xceCloudLoad")
            cell.post = ckPost
            
            return cell
        case .firebase:
            let fbPost = fbPostController.fbPosts[indexPath.row]
            cell.post = fbPost
            cell.delegate = self
            fbPostController.fetchImage(post: fbPost) { (image) in
                DispatchQueue.main.async {
                    UIView.transition(with: cell.contentView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                        cell.photoImageView.image = image
                    }, completion: nil)
                    cell.activityIndicator.stopAnimating()
                    cell.contentView.sendSubviewToBack(cell.activityIndicator)
                }
            }
        }
        return cell
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension FeedTableViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            switch selectedDB {
            case .cloudKit:
                let ckPost = CloudKitPostController.shared.ckPosts[indexPath.row]
                CloudKitPostController.shared.fetchImages(cKpost: ckPost) { _ in
                    
                }
               
            case .firebase:
                let fbPost = fbPostController.fbPosts[indexPath.row]
                fbPostController.fetchImage(post: fbPost) { _ in
                    
                }
            }
        }
    }
}

// MARK: - Navigation

extension FeedTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        performSegue(withIdentifier: Constants.toCommentVC, sender: cell)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.toCommentVC {
            guard let commentListVC = segue.destination as? CommentListTableViewController,
                let selectedCell = sender as? FeedTableViewCell,
                let indexPath = tableView.indexPath(for: selectedCell) else { return }
            
            commentListVC.commentDelegate = self
            switch selectedDB {
            case .cloudKit:
                let ckPost = CloudKitPostController.shared.ckPosts[indexPath.row]
                commentListVC.post = ckPost
                commentListVC.indexPath = indexPath
            case .firebase:
                let fbPost = fbPostController.fbPosts[indexPath.row]
                commentListVC.post = fbPost
                commentListVC.indexPath = indexPath
                commentListVC.fbCommentController = FBCommnetController()
            }
        }
    }
}

// MARK: - Custom Delegate

extension FeedTableViewController {
    
    func increaseFetchTimer() {
        if selectedDB == .cloudKit {
            DispatchQueue.main.async {
                self.navigationItem.title = "Fetching Time: \(String(format:"%.1f", CloudKitPostController.shared.fetchCounter))"
            }
        }
    }
    
    func timerCompleted() {
        debugPrint("Feching complete")
        switch selectedDB {
        case .cloudKit:
            DispatchQueue.main.async {
                self.navigationItem.title = "Fetching Time: \(String(format:"%.1f", CloudKitPostController.shared.fetchCounter))"
            }
        case .firebase:
            self.fbPostController.myTimer.stopTimer()
        }
    }
    
    
    func reloadCommentCount(_ indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FeedTableViewCell else { return }
        switch selectedDB {
        case .cloudKit:
            cell.commnetLabel.text = "Comments \(cell.post?.comments.count ??? "")"
            
        case .firebase:
            cell.commnetLabel.text = "Comments \(cell.post?.comments.count ??? "")"
        }
    }
    
    func didTapReportButton(_ cell: FeedTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        switch selectedDB {
        case .cloudKit:
            let ckPost = CloudKitPostController.shared.ckPosts[indexPath.row]
            let reportVC = showReport(with: ckPost)
            navigationController?.pushViewController(reportVC, animated: true)
        case .firebase:
            let fbPost = fbPostController.fbPosts[indexPath.row]
            let reportVC = showReport(with: fbPost)
            navigationController?.pushViewController(reportVC, animated: true)
        }
    }
    
    private func showReport(with post: Post) -> ReportViewController {
        let storyboard = AppStoryboard.ReportAbuse.instance
        let reportVC = storyboard.instantiateViewController(identifier: Constants.Storyboard.reportTVC, creator: { coder in
            return ReportViewController(coder: coder, post: post)
        })
        return reportVC
    }
    
    func didTapCommentButton(_ cell: FeedTableViewCell) {
        performSegue(withIdentifier: Constants.toCommentVC, sender: cell)
    }
}

// MARK: - MyTimerDelegate

extension FeedTableViewController: MyTimerDelegate {
    
    /// Firebase
    func updateTimeLable(counterStr: String) {
        self.navigationItem.title = "Fetching Time: \(counterStr)"
    }
}
