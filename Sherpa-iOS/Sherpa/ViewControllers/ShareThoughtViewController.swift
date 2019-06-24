//
//  ShareThoughtViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/23/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

class ShareThoughtViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var addButton: CustomButton!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ShareThoughtViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.text = ""
    }
}
