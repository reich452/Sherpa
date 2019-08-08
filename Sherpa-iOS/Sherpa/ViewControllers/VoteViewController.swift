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
    
    // MARK: - Properties
    
    var cloudKitEntry = PieChartDataEntry(value: 0)
    var firebaseEntry = PieChartDataEntry(value: 0)
    var voteDataEntries = [PieChartDataEntry]()
    var cloudKitCounter: Double = 50.0
    var firebaseCounter: Double = 50.0
    
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
        
        cloudKitEntry.value = cloudKitCounter
        cloudKitEntry.label = "CloudKit"
        
        firebaseEntry.value = firebaseCounter
        firebaseEntry.label = "Firebase"
        voteDataEntries = [firebaseEntry, cloudKitEntry]
    }
    
    func updateViews() {
        let chartDataSet = PieChartDataSet(entries: voteDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.firebaseDarkOrange, UIColor.cloudKitLightBlue]
        chartDataSet.colors = colors
        pieChartView.data = chartData
    }
    
    // MARK: - Actions
    
    @IBAction func cloudKitBtnTapped(_ sender: Any) {
        cloudKitCounter += 1
        cloudKitEntry.value = cloudKitCounter
        updateViews()
    }
    @IBAction func firebaseBtnTapped(_ sender: Any) {
        firebaseCounter += 1
        firebaseEntry.value = firebaseCounter
        updateViews()
    }
    
    
}
