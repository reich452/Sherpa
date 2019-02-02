//
//  ReadOrWriteTableViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 11/14/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

class ReadOrWriteTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    var dataBaseString = ""
    let options = ["Author", "Write"]
    let cellSpacing: CGFloat = 10
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.readOrWriteCell, for: indexPath)
        
        let option = options[indexPath.section]
        cell.textLabel?.text = option
        cell.textLabel?.textAlignment = .center
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacing
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    

    // MARK: - Visuial effect
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let clearColor = UIColor.clear
        cell.backgroundColor = clearColor
        cell.textLabel?.backgroundColor = UIColor(white: 1, alpha: 0.3)
        cell.textLabel?.clipsToBounds = true
        cell.textLabel?.layer.cornerRadius = 15
        cell.detailTextLabel?.backgroundColor = clearColor
    }
    
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        if segue.identifier == Constants.toAuthorTVC {
            guard let destinationVC = segue.destination as? AuthorTableViewController else { return }
            destinationVC.dataBaseString = dataBaseString
        }
   
    }
    
}

extension ReadOrWriteTableViewController {
    
    // MARK: - UI
    func setUpUI() {
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        let imageView = UIImageView(image: #imageLiteral(resourceName: "xcCloudKit_Icon"))
        tableView.backgroundView = imageView
        imageView.contentMode = .scaleAspectFill
        
        // Make a blur effect
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
        imageView.clipsToBounds = true
    }
}
