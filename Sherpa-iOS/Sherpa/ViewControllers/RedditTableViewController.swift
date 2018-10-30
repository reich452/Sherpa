//
//  RedditTableViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/30/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

class RedditTableViewController: UITableViewController, ActivityIndicatorPresenter {
    
    var activityIndicator = UIActivityIndicatorView()

    @IBAction func loadMorePosts(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Loading next page...", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        print("Loading next page...")
        RedditPostController.shared.fetchNextPagePosts { (posts, error) in
            
            DispatchQueue.main.async { [weak self] in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self?.tableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Lifecycle Functions & Initial setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.prefetchDataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        self.title = "/r/all/hot"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: nil, action: nil)
        activityIndicator.startAnimating()
        fetchInitialPosts()
    }
    
    
    // MARK: - Table view data source functions

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RedditPostController.shared.posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.redditCell, for: indexPath) as? RedditTableViewCell else { return UITableViewCell() }
        let rdPost = RedditPostController.shared.posts[indexPath.row]
        cell.rdPost = rdPost
        
        RedditPostController.shared.fetchThumbnail(rdPost: rdPost) { (newImage, error) in
            DispatchQueue.main.async {
                cell.rdPost = rdPost
                if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath == indexPath {
                    if cell.postThumbnail.image == nil {
                        cell.postThumbnail.image = #imageLiteral(resourceName: "redditDefaultImage")
                    } else {
                        cell.postThumbnail.image = newImage
                    }
                } else {
                    return
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: - 
      //  performSegue(withIdentifier: "toViewComments", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == RedditPostController.shared.posts.count - 1 {
            let alert = UIAlertController(title: nil, message: "Loading next page...", preferredStyle: .alert)
          
            present(alert, animated: true, completion: nil)
            print("Loading next page...")
            activityIndicator.startAnimating()

            RedditPostController.shared.fetchNextPagePosts { (_, _) in
                DispatchQueue.main.async { [weak self] in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    self?.tableView.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self?.activityIndicator.stopAnimating()
                }
            }
            dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: - Functions
    
    func fetchInitialPosts() {
        RedditPostController.shared.fetchPost { (_, _) in
            
            DispatchQueue.main.async { [weak self] in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self?.tableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
}

extension RedditTableViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let post = RedditPostController.shared.posts[indexPath.row]
            guard let postThumbnail = post.thumbnail, let postUrl = URL(string: postThumbnail) else {  return }
            
            URLSession.shared.dataTask(with: postUrl).resume()
            print("Prefetching \(post.title ?? "no prefetch")")
        }
    }
}
