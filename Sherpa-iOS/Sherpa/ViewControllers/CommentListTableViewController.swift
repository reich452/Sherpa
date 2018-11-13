//
//  CommentListTableViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 11/10/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

protocol DidPassUpdatedComments: class {
    func reloadCommentCount(_ indexPath: IndexPath)
}

class CommentListTableViewController: UITableViewController, CommentUpdatedToDelegate {

    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    // MARK: - Properties
    
    var post: Post? {
        didSet {
            loadViewIfNeeded()
            updateView()
        }
    }
    var indexPath: IndexPath?
    weak var commentDelegate: DidPassUpdatedComments?

    override func viewDidLoad() {
        super.viewDidLoad()
        CloudKitPostController.shared.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.commentDelegate != nil {
            guard let indexPath = indexPath else { return }
            self.commentDelegate?.reloadCommentCount(indexPath)
        }
    }
    
    // MARK: - Main
    func updateView() {
        guard let post = post else { return }
        photoImageView.image = post.image
    }
    // MARK: - Comment Delegate
    func commentsWereAddedTo() {
        DispatchQueue.main.async {
            let commentCount = self.post?.comments.count ?? 0
    
            let indexPath = IndexPath(row: commentCount - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let post = post,
            let title = commentTextField.text else { return }
        CloudKitPostController.shared.addComent(title, to: post) { (_) in
      
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return post?.comments.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.commentCell, for: indexPath)
        let comment = post?.comments[indexPath.row]
        
        cell.textLabel?.text = comment?.text
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
}
