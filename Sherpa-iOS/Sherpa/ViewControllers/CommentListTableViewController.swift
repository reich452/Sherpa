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
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CloudKitPostController.shared.delegate = self
        guard let post = post else { return }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        CloudKitPostController.shared.fetchComments(from: post) { (comments, error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if error != nil {
                DispatchQueue.main.async {
                    self.showNoActionAlert(titleStr: "Error loading comments for CKpost", messageStr: error?.localizedDescription ?? "Please try again", style: .cancel)
                }
            }
            guard let comments = comments else { return }
            self.post?.comments = comments
            if !comments.isEmpty {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
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
        DispatchQueue.main.async {
            self.photoImageView.image = post.image
        }
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
        CloudKitPostController.shared.addComent(title, to: post) { (comment) in
            
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return post?.comments.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.commentCell, for: indexPath)
        guard let comment = post?.comments[indexPath.row] else { return UITableViewCell() }
        
        cell.textLabel?.text = comment.text
        cell.detailTextLabel?.text = dateFormatter.string(from: comment.timestamp)
        
        return cell
    }
}
