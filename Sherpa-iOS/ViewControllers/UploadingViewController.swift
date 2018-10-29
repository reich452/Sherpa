//
//  UploadingViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

class UploadingViewController: UIViewController, ActivityIndicatorPresenter {
    
    
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var captionSpTextField: SherpaTextField!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: - Properties
    
    var activityIndicator = UIActivityIndicatorView()
    var cameraManager: CameraManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpSubViews()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    
    // MARK: - Actions
    
    @IBAction func selectImageButtonTapped(_ sender: UIButton) {
        selectImageButton.isHidden = true
        cameraManager = CameraManager()
        cameraManager?.showActionSheet(vc: self)
        cameraManager?.imagePickedBlock = { [weak self] (image) in
            self?.imageView.image = image
        }

    }
    
    @IBAction func updLoadButtonTapped(_ sender: UIButton) {
        guard let title = captionSpTextField.text,
            title != "", let image = imageView.image else { return }
    
        showActivityIndicator()
        sender.isEnabled = false
        uploadButton.layer.borderColor = UIColor.gray.cgColor
        uploadButton.setTitleColor(.gray, for: .normal)
        CloudKitPostController.shared.createPostWith(titleText: title, image: image) { (post) in
            if post != nil {
                DispatchQueue.main.async {
                    let sb = UIStoryboard(name: "Feed", bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: "FeedTableViewController") as? FeedTableViewController
                    self.hideActivityIndicator()
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
        }
    }
    

    // MARK: - Main
    
    func setUpUI() {
        selectImageButton.clipsToBounds = true
        selectImageButton.layer.cornerRadius = 15
        selectImageButton.layer.borderColor = UIColor.white.cgColor
        selectImageButton.layer.borderWidth = 1
        
        uploadButton.clipsToBounds = true
        uploadButton.layer.cornerRadius = 15
        uploadButton.layer.borderColor = UIColor.white.cgColor
        uploadButton.layer.borderWidth = 1
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.backgroundColor = UIColor.offsetBlack
        
        captionSpTextField.bottomBorderColor = UIColor.white
        
    }
    
    func setUpSubViews() {
        view.addVerticalGradientLayer(topColor: UIColor.cloudKitLightBlue, bottomColor: UIColor.cloudKitDarkBlue)
        
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toFeedTVC" {
            guard let destinationVC = segue.destination as? FeedTableViewController else { return }
            print(destinationVC.isViewLoaded)
        }
        
    }
    
    
}

