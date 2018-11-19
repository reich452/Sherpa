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
        return authorController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        authorController.checkFilter()

    }
    
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return authorController.createAuthorModel().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.authorCell, for: indexPath) as? AuthorTableViewCell else { return UITableViewCell() }
        
        let author = authorController.authorArray[indexPath.row]
    
        cell.author = author
        
        return cell
    }
    

}
