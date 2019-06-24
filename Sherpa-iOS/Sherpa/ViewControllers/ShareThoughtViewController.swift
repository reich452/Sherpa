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
    @IBOutlet weak var userNameTextField: UITextField!
    
    public var ckDiscussionController: CKDiscussionController!
    
    public enum DataBase {
        case cloudKit
        case firebase
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
    
    
    }
    
    
    @IBAction func randomizeBtnTapped(_ sender: Any) {
    }
    
    @IBAction func addBtnTapped(_ sender: CustomButton) {
        guard let text = textView.text, !text.isEmpty,
            let author = userNameTextField.text, !author.isEmpty  else {
            self.showNoActionAlert(titleStr: "Ops", messageStr: "You gotta enter some text and a username to share your thoughts", style: .cancel)
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        ckDiscussionController.createThought(text: text, author: author) { [weak self] (success, error) in
            guard let self = self else { return }
            if error != nil {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.showNoActionAlert(titleStr: "Error saving CKThought", messageStr: error?.localizedDescription ?? "Can't read CKError", style: .cancel)
                }
                if success == true {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
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
