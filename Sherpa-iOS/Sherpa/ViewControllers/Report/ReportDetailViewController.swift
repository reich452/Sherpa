//
//  ReportDetailViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/14/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

class ReportDetailViewController: UIViewController {
    
    public var post: Post!
    public var reportViewModel: ReportViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = reportViewModel.title
        view.backgroundColor = .primaryColor
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSubmittReportVC" {
            guard let submitReportVC = segue.destination as? SubmitReportVC else { return }
            submitReportVC.post = post
            submitReportVC.reportViewModel = reportViewModel
            if post.dataBase == .cloudKit {
                submitReportVC.ckReportController = CKReportController()
            } else {
                submitReportVC.fbReportController = FBReportController()
            }
        }
    }
}
