//
//  FBPostTableViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit
// TODO: - Take out and make reusable with feedTVC

class FBPostTableViewController: UITableViewController, ActivityIndicatorPresenter {
    
    // MARK: - Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
        self.showActivityIndicator()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadFbPosts()
    }
    
    // MARK: - Actions
    func reloadFbPosts() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        FireBasePostController.shared.fetchPosts { (_, error) in
            if error == nil {
                self.tableView.reloadData()
                self.hideActivityIndicator()
            }
           UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return FireBasePostController.shared.fbPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "fbPostCell", for: indexPath) as? FeedTableViewCell else { return UITableViewCell() }
        
        let fbPost = FireBasePostController.shared.fbPosts[indexPath.row]
        cell.post = fbPost
        return cell
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
        // TODO: - 
    }
    
    
}
