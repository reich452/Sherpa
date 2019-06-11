//
//  FeedTableViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController, FeedTableViewCellDelegate, DidPassUpdatedComments, FetchAndUploadCounter  {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var resultsArray: [CKPost]?
    var isSearching: Bool = false
    var counter = 0.0
    var totalCount = 0.0
    var activityIndicator = UIActivityIndicatorView()
    var timeInterval: TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        CloudKitPostController.shared.timerDelegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
        navigationController?.navigationBar.prefersLargeTitles = true
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postsChanged), name: Notification.Name.PostsChangedNotification, object: nil)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        CloudKitPostController.shared.fetchQueriedPosts { (didFinish, counter) in
            if didFinish != false {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                   let mil = CloudKitPostController.shared.rTimer.timeInterval.milliseconds
                    print(mil)
                }
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.PostsChangedNotification, object: nil)

    }
    
    @objc func postsChanged() {
        let indexPath = IndexPath(item: CloudKitPostController.shared.ckPosts.count - 1, section: 0)
        
        self.tableView.insertRows(at: [indexPath], with: .fade)
        
    }
    
    // MARK: - Custom Delegate
    
    func increaseFetchTimer() {
        DispatchQueue.main.async {
            self.navigationItem.title = "Fetching Time: \(String(format:"%.1f", CloudKitPostController.shared.fetchCounter))"
        }
    }
    
    func timerCompleted() {
        print("Feching complete")
        DispatchQueue.main.async {
            self.navigationItem.title = "Fetching Complete \(String(format:"%.1f", CloudKitPostController.shared.fetchCounter))"
        }
    }
    
    func didTapCommentButton(_ cell: FeedTableViewCell) {
       performSegue(withIdentifier: Constants.toCommentVC, sender: cell)
    }
    
    func reloadCommentCount(_ indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FeedTableViewCell else { return }
        cell.commnetLabel.text = "Comments \(cell.post?.comments.count ??? "")"
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? resultsArray?.count ?? 0 : CloudKitPostController.shared.ckPosts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as? FeedTableViewCell else { return UITableViewCell() }
        
        let dataSource = isSearching ? resultsArray : CloudKitPostController.shared.ckPosts
        let ckPost = dataSource?[indexPath.row]
        cell.delegate = self
        cell.post = ckPost
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.toCommentVC {
            guard let commentListVC = segue.destination as? CommentListTableViewController,
                let selectedCell = sender as? FeedTableViewCell,
                let indexPath = tableView.indexPath(for: selectedCell) else { return }
            let ckPost = CloudKitPostController.shared.ckPosts[indexPath.row]
            commentListVC.post = ckPost
            commentListVC.commentDelegate = self
            commentListVC.indexPath = indexPath
        }
    }
    
}

// MARK: - Search

extension FeedTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let posts = CloudKitPostController.shared.ckPosts
        let filteredPosts = posts.filter { $0.matches(searchTerm: searchText) }.compactMap { $0 as CKPost }
        resultsArray = filteredPosts
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        resultsArray = CloudKitPostController.shared.ckPosts
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
}
