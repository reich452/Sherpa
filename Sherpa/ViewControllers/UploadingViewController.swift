//
//  UploadingViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit
import Firebase

class UploadingViewController: ShiftableViewController, ActivityIndicatorPresenter {
    
    @IBOutlet private weak var selectImageButton: UIButton!
    @IBOutlet private weak var captionSpTextField: UITextField!
    @IBOutlet private weak var uploadButton: CustomButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var defaultUploadBtn: UIButton!
    @IBOutlet private weak var cancelBtn: UIButton!
    
    // MARK: - Properties
    // TODO: - Take Bool out and use Enum
    public var isCKupload = false
    public var activityIndicator = UIActivityIndicatorView()
    fileprivate var uploadTime: Double = 0.0
    private var cameraManager: CameraManager?
    private let blurEffect = UIBlurEffect(style: .light)
    private var visualEffectView: UIVisualEffectView?
    private lazy var fbPostController: FireBasePostController = {
        return FireBasePostController()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captionSpTextField.delegate = self
        setUpUI(selectedDb: isCKupload)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CloudKitPostController.shared.myTimer.resetTimer()
    }
    
    // MARK: - Actions
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        view.insertSubview(defaultUploadBtn, at: 2)
        view.insertSubview(selectImageButton, at: 2)
        
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView?.frame = imageView.frame
        guard let effectView = visualEffectView else { return }
        UIView.animate(withDuration: 1.0) {
            self.view.insertSubview(effectView, aboveSubview: self.imageView)
            sender.isHidden = true
        }
    }
    @IBAction func selectImageButtonTapped(_ sender: UIButton) {
        cameraManager = CameraManager()
        cameraManager?.showActionSheet(vc: self)
        cameraManager?.imagePickedBlock = { [weak self] (image) in
            guard let self = self else { return }
            self.cancelBtn.isHidden = false
            self.view.sendSubviewToBack(self.defaultUploadBtn)
            self.view.sendSubviewToBack(self.selectImageButton)
            self.visualEffectView?.removeFromSuperview()
            self.imageView.image = image
        }
    }
    
    @IBAction func updLoadButtonTapped(_ sender: UIButton) {
        switch isCKupload {
        case true:
            CloudKitPostController.shared.timerDelegate = self
            guard let title = captionSpTextField.text,
                title != "", let image = imageView.image else { return }
            
            showActivityIndicator()
            sender.isEnabled = false
            isCKupload = true
            uploadButton.layer.borderColor = UIColor.gray.cgColor
            uploadButton.setTitleColor(.gray, for: .normal)
            CloudKitPostController.shared.createPostWith(titleText: title, image: image) { (post) in
                self.hideActivityIndicator()
                if post == nil {
                    self.showNoActionAlert(titleStr: "Error", messageStr: "Error uploading to CloudKit", style: .cancel)
                }
            }
        case false:
            guard let title = captionSpTextField.text,
                title != "", let image = imageView.image else { return }
            showActivityIndicator()
            sender.isEnabled = false
            uploadButton.layer.borderColor = UIColor.gray.cgColor
            uploadButton.setTitleColor(.gray, for: .normal)
            sender.isEnabled = false
            uploadButton.layer.borderColor = UIColor.gray.cgColor
            uploadButton.setTitleColor(.gray, for: .normal)
            fbPostController.timerDelegate = self
            fbPostController.createPost(with: title, image: image) { (success, _) in
                self.hideActivityIndicator()
                if !success {
                    self.showNoActionAlert(titleStr: "Error", messageStr: "Error uploading to firebase", style: .cancel)
                }
            }
        }
    }
    
    // MARK: - Main
    
    private func setUpUI(selectedDb: Bool) {
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .primaryColor
        cancelBtn.isHidden = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.backgroundColor = .primaryColor
        captionSpTextField.tintColor = .white
        captionSpTextField.backgroundColor = .white
        captionSpTextField.textColor = .offsetBlack
        captionSpTextField.layer.cornerRadius = 20
        captionSpTextField.clipsToBounds = true 
        uploadButton.clipsToBounds = true
        captionSpTextField.placeholderColor(.gray)
        captionSpTextField.setLeftPaddingPoints(10)
        captionSpTextField.setRightPaddingPoints(10)
        title = "Upload"
        switch selectedDb {
        case true:
            uploadButton.setTitle("Upload to ☁️", for: .normal)
            uploadButton.setTitleColor(.white, for: .normal)
            uploadButton.isGradientBgOn = true
            uploadButton.bottomGradiant = .cloudKitDarkBlue
            uploadButton.topGradiant = .cloudKitLightBlue
            uploadButton.layer.borderColor = UIColor.cloudKitDarkBlue.cgColor
            defaultUploadBtn.setImage(#imageLiteral(resourceName: "xceBlueUpload"), for: .normal)
        case false:
            uploadButton.setTitle("Upload to 🔥", for: .normal)
            uploadButton.setTitleColor(.white, for: .normal)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toFeedTVC" {
            guard let destinationVC = segue.destination as? FeedTableViewController else { return }
            debugPrint(destinationVC.isViewLoaded)
        }
    }
}
// MARK: - CustomDelegate

extension UploadingViewController: FetchAndUploadCounter, OverlayVCDelegate {
    
    // MARK: - Timer delegate
    
    func timerCompleted() {
        let sb = UIStoryboard(name: "Overlay", bundle: nil)
        guard let overlayVC = sb.instantiateViewController(withIdentifier: "OverlayVC") as? OverlayVC else { return }
        overlayVC.delegate = self
        overlayVC.uploadTime = self.uploadTime
        DispatchQueue.main.async {
            self.present(overlayVC, animated: true, completion: nil)
        }
    }
    
    func increaseCkUploadTimer(time: Double) {
        DispatchQueue.main.async {
            self.uploadTime = time
            self.title = "Upload Time: \(time.formattedTime)"
        }
    }
    
    func increaseFbUploadTimer(time: Double) {
        debugPrint("😎 FB increase THREAD  is on main: \(Thread.isMainThread) /n  time \(time)")
        DispatchQueue.main.async {
            debugPrint("Time elapsed \(time)")
            self.uploadTime = time
            self.title = "Upload Time: \(time.formattedTime)"
        }
    }
    
    // MARK: - OverlayVC Delegate
    func dismissedVC() {
        navigationController?.popViewController(animated: true)
    }
}
