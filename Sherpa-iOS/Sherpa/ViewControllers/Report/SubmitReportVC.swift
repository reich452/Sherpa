//
//  SubmitReportVC.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/14/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

class SubmitReportVC: ShiftableViewController, OverlayVCDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    public var reportViewModel: ReportViewModel!
    public var post: Post!
    public var fbReportController: FBReportController!
    public var ckReportController: CKReportController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        titleLabel.text = reportViewModel.title
        let edges = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.textContainerInset = edges
        view.backgroundColor = .primaryColor
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHolderLabel.text = ""
    }
    
    @IBAction private func submitBtnTapped(_ sender: Any) {
        if textView.text.isEmpty {
            self.showNoActionAlert(titleStr: "Please Provide Details", messageStr: "Let us know why this post should be set to review and or removed", style: .cancel); return 
        }
        if post.dataBase == .cloudKit {
            ckReportController.createReport(with: reportViewModel.title, subTitle: reportViewModel.subTitle, reason: textView.text, fromPost: post) { (success, error) in
                if !success {
                    DispatchQueue.main.async {
                        self.showNoActionAlert(titleStr: "Error Sending Report", messageStr: "\(error?.localizedDescription ??? "Can't upload CKReport at this time")", style: .cancel)
                    }
                } else {
                    self.reportAddedToPost()
                }
            }
        } else {
            fbReportController.createReport(from: post, title: reportViewModel.title, subTitle: reportViewModel.subTitle, reason: textView.text) { (error) in
                if error == nil {
                   self.reportAddedToPost()
                } else {
                    self.showNoActionAlert(titleStr: "Error Sending Report", messageStr: error?.localizedDescription ?? "Cant send report from this post", style: .cancel)
                }
            }
        }
    }
    
    // MARK: - Delegates
    func reportAddedToPost() {
        let sb = UIStoryboard(name: "Overlay", bundle: nil)
        guard let overlayVC = sb.instantiateViewController(withIdentifier: "OverlayVC") as? OverlayVC else {
            titleLabel.text = "Thank you for reporting. We will review within 48 hours."
            return
        }
        overlayVC.message = "Thank you for submitting this report. We will review this information within 48 hours. Please contact the developer if you have any other questions"
        overlayVC.delegate = self
        DispatchQueue.main.async {
            self.textView.text = ""
            self.present(overlayVC, animated: true, completion: nil)
        }
    }
    
    func dismissedVC() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
