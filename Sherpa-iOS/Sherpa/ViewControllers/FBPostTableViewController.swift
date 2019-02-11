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
    var counter = 0.0
    
    private lazy var fbPostController: FireBasePostController = {
        let storageRef = StorageReference()
        let myTimer = MyTimer()
        let storageManager = StorageManager(storageRef: storageRef)
        return FireBasePostController(storageManager: storageManager, myTimer: myTimer)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
        fbPostController.timerDelegate = self
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
                        cell.photoImageView.image = image
                } else { return }
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            print("Threeee")
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
        // TODO: - 
    }
}
// MARK: - FetchAndUploadCounter Delegate
extension FBPostTableViewController: FetchAndUploadCounter {
    func timerCompleted() {
        print("Thread is on main \(Thread.isMainThread)")
      
        let totalTime = fbPostController.myTimer.stop()

        fbPostController.myTimer.stopTimer()
        print(" The total time \(totalTime)")
        fbPostController.rTimer.eventHandler = {
            let string = self.fbPostController.rTimer.counter
            print("🌶 R TOTAL COURNTER \(string)")
            self.fbPostController.rTimer.suspend()
        }
        DispatchQueue.main.async {
            self.navigationItem.title = "Fetching Time \(self.fbPostController.myTimer.runTimer())"
        }
    }
    
    func increaseTimer() {
        fbPostController.myTimer.startTimer()
        // TODO: --  add this up
        fbPostController.rTimer.eventHandler = {
           let string = self.fbPostController.rTimer.runTimer()
            print("  👻 R TIMER ============= \(string)")
        }
        DispatchQueue.main.async {
            self.navigationItem.title = "Fetching time \(self.fbPostController.myTimer.runTimer())"
        }
    }
    
    
}
