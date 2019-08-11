//
//  ReadTableViewController.swift
//  Sherpa
//
//  Created by Nick Reichard on 11/17/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

import UIKit

class AuthorTableViewController: UITableViewController {
    
    var dataBaseString: String?
    
    lazy var authorController: AuthorController = {
        let authorController = AuthorController(filterString: dataBaseString ?? "CloudKit")
        authorController.checkDBname(str: dataBaseString ?? "CloudKit")
        return authorController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.backgroundColor = .primaryColor
        self.title = authorController.filterString
    }
  
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return authorController.authorArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.authorCell, for: indexPath) as? AuthorTableViewCell else { return UITableViewCell() }
        
        let author = authorController.authorArray[indexPath.row]
    
        cell.author = author
        print(indexPath.row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.offsetBlack
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .center
    }
}

