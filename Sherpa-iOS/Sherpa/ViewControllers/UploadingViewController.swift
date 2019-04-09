//
//  UploadingViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit
import Firebase

class UploadingViewController: UIViewController, ActivityIndicatorPresenter {
    
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var captionSpTextField: SherpaTextField!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fbUploadButton: UIButton!
    
    
    // MARK: - Properties
    
    var activityIndicator = UIActivityIndicatorView()
    var cameraManager: CameraManager?
    var uploadTime: Double = 0.0
    var isCKupload = false
    private lazy var fbPostController: FireBasePostController = {
        let storageRef = StorageReference()
        let storageManager = StorageManager(storageRef: storageRef)
        return FireBasePostController(storageManager: storageManager)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpSubViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CloudKitPostController.shared.myTimer.resetTimer()
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
        CloudKitPostController.shared.timerDelegate = self
        guard let title = captionSpTextField.text,
            title != "", let image = imageView.image else { return }
        
        showActivityIndicator()
        sender.isEnabled = false
        isCKupload = true
        uploadButton.layer.borderColor = UIColor.gray.cgColor
        uploadButton.setTitleColor(.gray, for: .normal)
        CloudKitPostController.shared.createPostWith(titleText: title, image: image) { (post) in
            if post != nil {
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                }
            } else {
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                }
            }
        }
    }
    
    @IBAction func uploadFBbuttonTapped(_ sender: UIButton) {
        guard let title = captionSpTextField.text,
            title != "", let image = imageView.image else { return }
        showActivityIndicator()
        sender.isEnabled = false
        uploadButton.layer.borderColor = UIColor.gray.cgColor
        uploadButton.setTitleColor(.gray, for: .normal)
        sender.isEnabled = false
        fbUploadButton.layer.borderColor = UIColor.gray.cgColor
        fbUploadButton.setTitleColor(.gray, for: .normal)
        fbPostController.timerDelegate = self
        fbPostController.createPost(with: title, image: image) { (success, _) in
            if success  {
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                }
            } else {
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
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
        fbUploadButton.clipsToBounds = true
        fbUploadButton.layer.cornerRadius = 15
        fbUploadButton.layer.borderColor = UIColor.white.cgColor
        fbUploadButton.layer.borderWidth = 1
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

extension UploadingViewController: FetchAndUploadCounter, OverlayVCDelegate {
    
    // MARK: - CustomDelegate
    
    func timerCompleted() {
        print("STOPPPPPED")
        let sb = UIStoryboard(name: "Overlay", bundle: nil)
        guard let overlayVC = sb.instantiateViewController(withIdentifier: "OverlayVC") as? OverlayVC else { return }
        overlayVC.delegate = self
        overlayVC.uploadTime = self.uploadTime
        DispatchQueue.main.async {
            self.present(overlayVC, animated: true, completion: nil)
        }
    }
    
    func increaseCkUploadTimer(time: Double) {
        print("The THREAD \(Thread.isMainThread)")
        DispatchQueue.main.async {
            self.uploadTime = time
            self.title = "Upload Time: \(time.formattedTime)"
        }
    }
    
    func increaseFbUploadTimer(time: Double) {
        print("😎 FB increase THREAD  is on main: \(Thread.isMainThread) /n  time \(time)")
        DispatchQueue.main.async {
            print("Time elapsed \(time)")
            self.uploadTime = time
            self.title = "Upload Time: \(time.formattedTime)"
        }
    }
    
    // MARK: - OverlayVC Delegate
    func dismissedVC() {
        if isCKupload == true {
            let sb = UIStoryboard(name: Constants.feedSB, bundle: nil)
            guard let vc = sb.instantiateViewController(withIdentifier: Constants.feedTVC) as? FeedTableViewController else { return }
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let sb = UIStoryboard(name: Constants.firbaseSB, bundle: nil)
            guard let vc = sb.instantiateViewController(withIdentifier: Constants.fbFeedTVC) as? FBPostTableViewController else { return }
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
