//
//  CloudKitTableViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 10/27/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

enum SelectedIconDB {
    case cloudKit
    case firebase
}

class DataBaseActionTVC: UITableViewController, ActionTableViewCellDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .sherpaBackgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: - Main
    
    func hideSelectedObjects(sender: ActionTableViewCell) {
        
        if self.tabBarController?.selectedIndex == 1 {
            sender.iconImageView.image = #imageLiteral(resourceName: "xcCloudKit_logo")
            sender.actionLabel.textColor = .cloudKitLightBlue
            
        } else {
            sender.iconImageView.image = #imageLiteral(resourceName: "xcFirebase_logo")
            sender.actionLabel.textColor = .firebaseDarkOrange
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Constants.dataBaseTVCarray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cloudKitCell, for: indexPath) as? ActionTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        cell.backgroundColor = .sherpaBackgroundColor
        
        switch tabBarController?.selectedIndex{
        case 0:
            fallthrough
        case 1:
            cell.selectedDB = .cloudKit
            checkCaseOne(indexPath: indexPath, cell: cell)
          
        case 2:
            cell.selectedDB = .firebase
            checkCaseTwo(indexPath: indexPath, cell: cell)
        default:
            print("oh 💩 you  need to fix this \(#file) \(#function)")
        }
        
        return cell
    }
    
    // MARK: - Helper funcions
    
    func checkCaseOne(indexPath: IndexPath, cell: ActionTableViewCell) {
        cell.iconImageView.clipsToBounds = true
        if indexPath.row == 0 {
            cell.actionLabel.isHidden = true
        } else if indexPath.row > 0 {
            let objectAtRow = Constants.dataBaseTVCarray[indexPath.row]
            cell.actionLabel.text = objectAtRow
            cell.iconImageView.isHidden = true
        }
    }
    
    func checkCaseTwo(indexPath: IndexPath, cell: ActionTableViewCell) {
        if indexPath.row == 0 {
            cell.actionLabel.isHidden = true
            cell.iconImageView.isHidden = true
            cell.secondIconImageView.image = #imageLiteral(resourceName: "xcFirebase_logo")
        } else if indexPath.row > 0 {
            let objectAtRow = Constants.dataBaseTVCarray[indexPath.row]
            cell.actionLabel.text = objectAtRow
            cell.iconImageView.isHidden = true
            cell.secondIconImageView.isHidden = true
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}
