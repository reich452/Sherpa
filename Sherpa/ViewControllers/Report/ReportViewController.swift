//
//  ReportViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/14/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var reportOptions = [ReportViewModel]()
    // TODO: move this out of the VC. 
    let post: Post
    
    // MARK: - Init
    
    init?(coder: NSCoder, post: Post) {
        self.post = post
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a Post.")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .primaryColor
        
        reportOptions = ReportViewModel.buildReportSelectionFrom(post: post)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReportDetail" {
            guard let reportDetialVC = segue.destination as? ReportDetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow else { return }
            let reportViewModel = self.reportOptions[indexPath.row]
            reportDetialVC.post = post
            reportDetialVC.reportViewModel = reportViewModel
        }
    }
}

extension ReportViewController: UITableViewDataSource {
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reportOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath)
        let report = reportOptions[indexPath.row]
        
        cell.textLabel?.text = report.title
        cell.detailTextLabel?.text = report.subTitle
        return cell
    }
}
