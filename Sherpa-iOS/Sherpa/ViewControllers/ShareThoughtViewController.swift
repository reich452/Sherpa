//
//  ShareThoughtViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 6/23/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit

protocol ShareThoughtViewControllerDelegate: class {
    func reloadThoughts(_ thought: Thought)
}

class ShareThoughtViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var addButton: CustomButton!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var titleTextField: UITextField!
    
    private var didClear = true
    public var ckDiscussionController: CKDiscussionController?
    public var selectedDB: SelectedIconDB!
    public var fbDiscussionController: FBDiscussionController?
    weak var delegate: ShareThoughtViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        userNameTextField.delegate = self
        textView.delegate = self
        setupHideKeyboardOnTap()
        setUpUI()
    }
    
    
    // MARK: - Actions
    
    @IBAction func randomizeBtnTapped(_ sender: UIButton) {
        userNameTextField.text = randomName()
        didClear = !didClear
        switch didClear {
        case true:
            userNameTextField.text = ""
            sender.setTitle("Randomize Me!", for: .normal)
        case false:
            sender.setTitle("Clear", for: .normal)
        }
    }
    
    @IBAction func addBtnTapped(_ sender: CustomButton) {
        guard let body = textView.text, !body.isEmpty,
            let title = titleTextField.text, !title.isEmpty,
            let author = userNameTextField.text, !author.isEmpty  else {
                self.showNoActionAlert(titleStr: "Ops", messageStr: "All fields need to be filled in to share your thought", style: .cancel)
                return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        if selectedDB == .cloudKit {
            ckDiscussionController?.createThought(author: author, title: title, body: body) { [weak self] (ckThought, error) in
                guard let self = self else { return }
                if error != nil {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.showNoActionAlert(titleStr: "Error saving CKThought", messageStr: error?.localizedDescription ?? "Can't read CKError", style: .cancel)
                    }
                }
                guard let thought = ckThought else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.dismiss(animated: true, completion: {
                        self.delegate?.reloadThoughts(thought)
                    })
                }
            }
        } else {
            fbDiscussionController?.createFBThought(author: author, title: title, body: body, completion: { [weak self] (result)  in
                guard let self = self else { return }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch result {
                case .success(let thought):
                    self.dismiss(animated: true, completion: {
                        self.delegate?.reloadThoughts(thought)
                    })
                case .failure(let error):
                    self.showNoActionAlert(titleStr: "Error saving CKThought", messageStr: error.localizedDescription, style: .cancel)
                }
            })
        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Class Methods
    class func storyBoardInstance() -> ShareThoughtViewController? {
        return UIStoryboard(name: "ShareThought", bundle: nil).instantiateInitialViewController() as? ShareThoughtViewController
    }
    
    
}

extension ShareThoughtViewController: UITextViewDelegate, UITextFieldDelegate {
    
    // MARK: - Field Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case userNameTextField:
            titleTextField.becomeFirstResponder()
        case titleTextField:
            textView.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.text = ""
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" || textView.text == " " {
            placeholderLabel.text = "Share your thought..."
        }
    }
}

extension ShareThoughtViewController {
    
    // MARK: - UI
    
    func setUpUI() {
        view.backgroundColor = .primaryColor
        userNameTextField.setBottomBorder(withColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        titleTextField.setBottomBorder(withColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        textView.addAccessoryView("Share your thought...")
        if selectedDB == .cloudKit {
            titleLabel.text = "CloudKit"
        } else {
            titleLabel.text = "Firebase"
        }
    }
    
    func randomName() -> String {
        let names = ["Sally Sall", "Bruce Lee", "Tom Cruise", "Taylor Swift", "Beyonce", "Elvis Presley", "Kim Kardashian", "Ariana Grande", "Snoop Dog"]
        return names.randomElement()!
    }
}
