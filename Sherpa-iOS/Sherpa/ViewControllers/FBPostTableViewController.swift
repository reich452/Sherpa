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
    @IBOutlet weak var searchBar: UISearchBar!
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

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "fbPostCell", for: indexPath) as? FeedTableViewCell else { return UITableViewCell() }
        
        let fbPost = fbPostController.fbPosts[indexPath.row]
        cell.post = fbPost
        if fbPost.image == nil {
            fbPostController.fetchImage(urlString: fbPost.imageStringURL) { (image) in
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
        
        // TODO: - 
    }
}
// MARK: - FetchAndUploadCounter Delegate

extension FBPostTableViewController: FetchAndUploadCounter, MyTimerDelegate {
    
    func updateTimeLable(counterStr: String) {
        self.navigationItem.title = counterStr
    }
    
    func timerCompleted() {
        self.fbPostController.myTimer.stopTimer()
    }
    
}
