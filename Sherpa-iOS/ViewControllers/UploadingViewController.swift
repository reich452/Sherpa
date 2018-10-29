//
//  UploadingViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/29/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

class UploadingViewController: UIViewController {
    
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var captionSpTextField: SherpaTextField!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    
    // MARK: - Properties
  
    var cameraManager: CameraManager?

  
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setUpSubViews()
    }
    
    // MARK: - Actions
    
    @IBAction func selectImageButtonTapped(_ sender: UIButton) {
        cameraManager = CameraManager()
        cameraManager?.showActionSheet(vc: self)
        cameraManager?.imagePickedBlock = { [weak self] (image) in
            self?.imageView.image = image
        }

    }
    
    @IBAction func updLoadButtonTapped(_ sender: UIButton) {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
