//
//  VoteViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 8/8/19.
//  Copyright © 2019 Nick Reichard. All rights reserved.
//

import UIKit
import Charts

class VoteViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var dbStackView: UIStackView!
    @IBOutlet weak var cloudKitBtn: UIButton!
    @IBOutlet weak var firebaseBtn: UIButton!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var ckVotedImageView: UIImageView!
    @IBOutlet weak var fbVotedImageView: UIImageView!
    
    // MARK: - Properties
    
    private var cloudKitEntry = PieChartDataEntry(value: 0)
    private var firebaseEntry = PieChartDataEntry(value: 0)
    private var voteDataEntries = [PieChartDataEntry]()
    private var vote: Vote?
    var voteController: VoteController?
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.lightGray
        activityIndicator.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2.5)
        self.view.addSubview(activityIndicator)
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateViews()
    }
    
    // MARK: - Main
    
    func setupUI() {
        view.backgroundColor = .primaryColor
        cloudKitBtn.layer.cornerRadius = 15
        cloudKitBtn.clipsToBounds = true
        firebaseBtn.layer.cornerRadius = 15
        firebaseBtn.clipsToBounds = true
        
        cloudKitEntry.label = "CloudKit"
        firebaseEntry.label = "Firebase"
        pieChartView.holeColor = UIColor.offsetBlack
        ckVotedImageView.isHidden = true
        fbVotedImageView.isHidden = true
    }
    
    func updateViews() {
        checkVote()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        voteController?.fetchVoteCount { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let vote):
                self.vote = vote
                self.cloudKitEntry.value = Double(vote.cloudKitCount)
                self.firebaseEntry.value = Double(vote.firebaseCount)
                self.voteDataEntries = [self.firebaseEntry, self.cloudKitEntry]
                let chartDataSet = PieChartDataSet(entries: self.voteDataEntries, label: nil)
                let chartData = PieChartData(dataSet: chartDataSet)
                
                let colors = [UIColor.firebaseDarkOrange, UIColor.cloudKitLightBlue]
                chartDataSet.colors = colors
                self.pieChartView.data = chartData
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            case .failure(let error):
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true 
                self.showNoActionAlert(titleStr: "Error Getting Live Votes", messageStr: error.localizedDescription, style: .cancel)
            }
        }
    }
    
    func checkVote() {
        if voteController?.didVoteForCloudKit() == true {
            let sequence = AnimationSequence(withStepDuration: 0.5)
            sequence.doStep {
                self.titleLabel.text = "You voted for CloudKit"
            }
            sequence.execute()
            let secondSq = AnimationSequence(withStepDuration: 0.6)
            secondSq.execute()
            sequence.onCompletion {
                self.ckVotedImageView.isHidden = false
            }
            
        } else if voteController?.didVoteForFirebase() == true {
            let sequence = AnimationSequence(withStepDuration: 0.5)
            sequence.doStep {
                self.titleLabel.text = "You voted for Firebase"
            }
            sequence.execute()
            let secondSq = AnimationSequence(withStepDuration: 0.6)
            secondSq.execute()
            sequence.onCompletion {
                self.fbVotedImageView.isHidden = false
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cloudKitBtnTapped(_ sender: Any) {
        voteController?.updateVote(dbVoteKey: .cloudKitCount, compeletion: { (result) in
            switch result {
            case .success(_):
                print("A user updated")
                self.updateViews()
            case .failure(let error):
                
                self.showNoActionAlert(titleStr: "Error Updating Backend", messageStr: error.localizedDescription, style: .cancel)
            }
        }) { (message) in
            self.showNoActionAlert(titleStr: message, messageStr: "Can't vote twice 🤓. Thanks for voting!", style: .cancel)
        }
    }
    @IBAction func firebaseBtnTapped(_ sender: Any) {
        voteController?.updateVote(dbVoteKey: .firebaseCount, compeletion: { (result) in
            switch result {
            case .success(_):
                print("A user updated")
                self.updateViews()
            case .failure(let error):
                
                self.showNoActionAlert(titleStr: "Error Updating Backend", messageStr: error.localizedDescription, style: .cancel)
            }
        }) { (message) in
            self.showNoActionAlert(titleStr: message, messageStr: "Can't vote twice 🤓. Thanks for voting!", style: .cancel)
        }
    }
    
}
