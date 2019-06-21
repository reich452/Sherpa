//
//  CommentListTableViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 11/10/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit
import Firebase


protocol DidPassUpdatedComments: class {
    func reloadCommentCount(_ indexPath: IndexPath)
}

class CommentListTableViewController: UITableViewController, CommentUpdatedToDelegate {
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    // MARK: - Properties
    public var indexPath: IndexPath?
    public weak var commentDelegate: DidPassUpdatedComments?
    var fbCommentController: FBCommnetController?
    var didSeeFbComments = false
    var didSeeCkComments = false
    
    public var post: Post? {
        didSet {
            loadViewIfNeeded()
            updateView()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CloudKitPostController.shared.delegate = self
        commentTextField.delegate = self
        tableView.separatorColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let post = post else { return }
        checkDB(post: post)
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
        if post.dataBase == .cloudKit {
            DispatchQueue.main.async {
                self.photoImageView.image = post.image
            }
        }
    }
    
    func checkDB(post: Post) {
        if post.dataBase == .cloudKit {
            loadCloudKit(post: post)
        } else {
            self.photoImageView.image = post.image
            loadFBComments(post: post)
        }
    }
    
    func loadCloudKit(post: Post) {
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
    
    func loadFBComments(post: Post) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        fbCommentController?.fetchFBComments(from: post) { (fbComments, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if error == nil {
                guard let fbComments = fbComments else { return }
                let fbPost = post as! FBPost
                fbPost.comments = fbComments
                self.tableView.reloadData()
            }
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
            let title = commentTextField.text, !title.isEmpty else { return }
        commentTextField.text = ""
        if post.dataBase == .cloudKit {
            CloudKitPostController.shared.addComent(title, to: post) { (comment) in
                
            }
        } else {
            fbCommentController?.addCommentTo(post: post, text: title) { (fbComment, error) in
                if let error = error {
                    self.showNoActionAlert(titleStr: "Error with Firebase upload", messageStr: error.localizedDescription, style: .cancel)
                } else {
                    let indexPath = IndexPath(row: post.comments.count - 1, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return post?.comments.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.commentCell, for: indexPath)
        guard let comment = post?.comments[indexPath.row] else { return UITableViewCell() }
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        cell.textLabel?.text = comment.text
        cell.accessoryType = .disclosureIndicator
        switch post!.dataBase {
        case .cloudKit:
            cell.detailTextLabel?.text = DateHelper.shared.dateToString(date: comment.timestamp)
            let cellImage = didSeeCkComments ? #imageLiteral(resourceName: "xceGrayCircle") : #imageLiteral(resourceName: "xceBlueCircle")
            cell.imageView?.image = cellImage
        case .firebase:
            guard let fbComment = comment as? FBComment else { return UITableViewCell() }
            let date = Date(timeIntervalSince1970: TimeInterval(fbComment.timeInt/1000))
            cell.detailTextLabel?.text = " \(DateHelper.shared.dateToString(date: date))"
            let cellImage = didSeeFbComments ? #imageLiteral(resourceName: "xceGrayCircle") : #imageLiteral(resourceName: "xceBlueCircle")
            cell.imageView?.image = cellImage
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let sb = UIStoryboard(name: Constants.reportAbuse, bundle: nil)
        guard let reportTVC = sb.instantiateViewController(withIdentifier: Constants.reportTVC) as? ReportTableViewController else { return }
        reportTVC.post = self.post
        navigationController?.pushViewController(reportTVC, animated: true)
    }
}

extension CommentListTableViewController: UITextFieldDelegate {
    
    // MARK: - TextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
