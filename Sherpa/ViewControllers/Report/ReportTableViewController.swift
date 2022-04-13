//
//  ReportTableViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/14/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

class ReportTableViewController: UITableViewController {
    
    // MARK: - Properties

    var post: Post?
    fileprivate var reportVMs = [ReportViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .primaryColor
        guard let post = post else { return }
        createUI(post: post)
    
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reportVMs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath)
        let report = reportVMs[indexPath.row]
        
        cell.textLabel?.text = report.title
        cell.detailTextLabel?.text = report.subTitle
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReportDetail" {
            guard let reportDetialVC = segue.destination as? ReportDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            let reportViewModel = self.reportVMs[indexPath.row]
            reportDetialVC.post = post
            reportDetialVC.reportViewModel = reportViewModel
            
        }
    }
}


private extension ReportTableViewController {
    
    // MARK: - UI
    func createUI(post: Post) {
        let report1 = ReportViewModel(title: "Self Injury", subTitle: "Eating disorders, cutting or promoting suicide", post: post)
        let report2 = ReportViewModel(title: "Violence or Harm", subTitle: "Graphic injury, unlawful activity, dangerouse or criminal organization", post: post)
        let report3 = ReportViewModel(title: "Sale or promotion of filearms", subTitle: "", post: post)
        let report4 = ReportViewModel(title: "Harassment or bullying", subTitle: "Including cyber bullying", post: post)
        let report5 = ReportViewModel(title: "Hate speech or symbols", subTitle: "Racest, homophobic or sexist slurs", post: post)
        let report6 = ReportViewModel(title: "Nudity or pornography", subTitle: "Any relation to XXX images", post: post)
        let report7 = ReportViewModel(title: "Copyright or trademark infringement", subTitle: "Intellectual property violation", post: post)
        let report8 = ReportViewModel(title: "I just don't like it", subTitle: "I don't want to see this", post: post)
        self.reportVMs = [report1, report2, report3, report4, report5, report6, report7, report8]
    }
  
}
