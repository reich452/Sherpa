//
//  FeedTableViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController, ActivityIndicatorPresenter {

    
    @IBOutlet weak var searchBar: UISearchBar!
    var resultsArray: [CKPost]?

    var isSearching: Bool = false
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
    
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
        self.showActivityIndicator()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postsChanged), name: Notification.Name.PostsChangedNotification, object: nil)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        CloudKitPostController.shared.fetchQueriedPosts { (didFinish) in
            if didFinish != false {
                self.hideActivityIndicator()
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func postsChanged() {
        let indexPath = IndexPath(item: CloudKitPostController.shared.ckPosts.count - 1, section: 0)
        
        self.tableView.insertRows(at: [indexPath], with: .fade)
    }
    

    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? resultsArray?.count ?? 0 : CloudKitPostController.shared.ckPosts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as? FeedTableViewCell else { return UITableViewCell() }
        
        let dataSource = isSearching ? resultsArray : CloudKitPostController.shared.ckPosts
        let ckPost = dataSource?[indexPath.row]
        cell.post = ckPost
        
        return cell
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
