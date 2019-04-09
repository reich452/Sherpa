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
        guard let comment = post?.comments[indexPath.row] else { return UITableViewCell() }
        
        cell.textLabel?.text = comment.text
        cell.detailTextLabel?.text = dateFormatter.string(from: comment.timestamp)
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
}

class ISO8601DateParser {
    
    private static var calendarCache = [Int : Calendar]()
    private static var components = DateComponents()
    
    private static let year = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    private static let month = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    private static let day = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    private static let hour = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    private static let minute = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    private static let second = UnsafeMutablePointer<Float>.allocate(capacity: 1)
    private static let hourOffset = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    private static let minuteOffset = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    
    static func parse(_ dateString: String) -> Date? {
        
        let parseCount = withVaList([year, month, day, hour, minute,
                                     second, hourOffset, minuteOffset], { pointer in
                                        vsscanf(dateString, "%d-%d-%dT%d:%d:%f%d:%dZ", pointer)
        })
        
        components.year = year.pointee
        components.minute = minute.pointee
        components.day = day.pointee
        components.hour = hour.pointee
        components.month = month.pointee
        components.second = Int(second.pointee)
        
        // Work out the timezone offset
        
        if hourOffset.pointee < 0 {
            minuteOffset.pointee = -minuteOffset.pointee
        }
        
        let offset = parseCount <= 6 ? 0 :
            hourOffset.pointee * 3600 + minuteOffset.pointee * 60
        
        // Cache calendars per timezone
        // (setting it each date conversion is not performant)
        
        if let calendar = calendarCache[offset] {
            return calendar.date(from: components)
        }
        
        var calendar = Calendar(identifier: .gregorian)
        guard let timeZone = TimeZone(secondsFromGMT: offset) else { return nil }
        calendar.timeZone =  timeZone
        calendarCache[offset] = calendar
        return calendar.date(from: components)
        
    }
    
}
