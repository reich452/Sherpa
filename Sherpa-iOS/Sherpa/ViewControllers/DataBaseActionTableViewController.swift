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

class DataBaseActionTVC: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .primaryColor
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tabBarController?.tabBar.isHidden = false 
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Constants.dataBaseTVCarray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cloudKitCell, for: indexPath) as? ActionTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        cell.pushVCDelegate = self 
        cell.backgroundColor = .primaryColor
        
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
            debugPrint("oh 💩 you  need to fix this \(#file) \(#function)")
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
        if segue.identifier == "toUpLoadingVC" {
            guard let destinationVC = segue.destination as? UploadingViewController else { return }
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
}

// MARK: - Custom Delegate
extension DataBaseActionTVC: ActionTableViewCellDelegate {
    
    // MARK: - UI
    func setUpTitle(tab: SelectedIconDB) {
        switch tab {
        case .cloudKit:
            self.title = "CloudKit"
        case .firebase:
            self.title = "Firebase"
        }
    }
    
    func hideSelectedObjects(sender: ActionTableViewCell) {
        setUpTitle(tab: sender.selectedDB ?? .cloudKit)
        if self.tabBarController?.selectedIndex == 1 {
            sender.iconImageView.image = #imageLiteral(resourceName: "xcCloudKit_logo")
            sender.actionLabel.textColor = .cloudKitLightBlue
            
        } else {
            sender.iconImageView.image = #imageLiteral(resourceName: "xcFirebase_logo")
            sender.actionLabel.textColor = .firebaseDarkOrange
        }
    }
    
    // MARK: - Custom Delegate Segue
    
    // TODO: Clean up and make New VC
    func performSegueFrom(cell: ActionTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        switch indexPath?.row {
        case 0:
            let sb = UIStoryboard(name: "Discussion", bundle: nil)
            guard let vc = sb.instantiateViewController(withIdentifier: Constants.discussionTVC) as? DiscussionTableViewController else { return }
            if cell.selectedDB == .cloudKit {
                vc.selectedDB = .cloudKit
                vc.cKDiscussionController = CKDiscussionController()
            } else {
                vc.selectedDB = .firebase
                vc.fbDiscussionController = FBDiscussionController()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            if cell.selectedDB == .cloudKit {
                let sb = UIStoryboard(name: "Feed", bundle: nil)
                guard let vc = sb.instantiateViewController(withIdentifier: Constants.feedTVC) as? FeedTableViewController else { return }
                vc.selectedDB = .cloudKit
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let sb = UIStoryboard(name: "Feed", bundle: nil)
                guard let vc = sb.instantiateViewController(withIdentifier: Constants.feedTVC) as? FeedTableViewController else { return }
                vc.selectedDB = .firebase
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 2:
            if cell.selectedDB == .cloudKit {
                let sb = UIStoryboard(name: "Uploading", bundle: nil)
                guard let vc = sb.instantiateViewController(withIdentifier: Constants.uploadVC) as? UploadingViewController else { return }
                vc.isCKupload = true
                
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let sb = UIStoryboard(name: "Uploading", bundle: nil)
                guard let vc = sb.instantiateViewController(withIdentifier: Constants.uploadVC) as? UploadingViewController else { return }
                vc.isCKupload = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        default:
            debugPrint("performSegueFrom(cell: ActionTableViewCell broke: \(#file) \(#function)")
        }
    }
}
