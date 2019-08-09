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
    
    var cloudKitEntry = PieChartDataEntry(value: 0)
    var firebaseEntry = PieChartDataEntry(value: 0)
    var voteDataEntries = [PieChartDataEntry]()
    var cloudKitCounter: Double = 1
    var firebaseCounter: Double = 1
    var vote: Vote?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateViews()
    }
    
    // MARK: - Main
    
    func setupUI() {
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
        VoteController.shared.fetchVoteCount { [weak self] (result) in
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
            case .failure(let error):
                self.showNoActionAlert(titleStr: "Error Getting Live Votes", messageStr: error.localizedDescription, style: .cancel)
            }
        }
    }
    
    func checkVote() {
        if VoteController.shared.didVoteForCloudKit() == true {
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
            
        } else if VoteController.shared.didVoteForFirebase() == true {
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
    
    @IBAction func cloudKitBtnTapped(_ sender: Any) {
        VoteController.shared.updateVote(dbVoteKey: .cloudKitCount, compeletion: { (result) in
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
        VoteController.shared.updateVote(dbVoteKey: .firebaseCount, compeletion: { (result) in
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
