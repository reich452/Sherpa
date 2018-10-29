//
//  FeedTableViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController, UISearchBarDelegate, ActivityIndicatorPresenter, PostsWereAddedToDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isSearching: Bool = false
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        CloudKitPostController.shared.delegate = self
        
    
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
        self.showActivityIndicator()
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
    
    func postsWereAddedTo() {
        let indexPath = IndexPath(item: CloudKitPostController.shared.ckPosts.count - 1, section: 0)
        
        self.tableView.insertRows(at: [indexPath], with: .fade)
    }
    

    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CloudKitPostController.shared.ckPosts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as? FeedTableViewCell else { return UITableViewCell() }
        
        let ckPost = CloudKitPostController.shared.ckPosts[indexPath.row]
        
        cell.ckPost = ckPost
        
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
