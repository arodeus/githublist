//
//  ViewController+TableView.swift
//  MWGitHubList
//
//  Created by Diego Giardinetto on 22/04/17.
//  Copyright © 2017 MinionWorks. All rights reserved.
//

import UIKit

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let item = self.fetchedResultsController.object(at: indexPath) as! GHLItemDetails
        cell.textLabel?.text = item.login
        cell.detailTextLabel?.text = item.name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = self.fetchedResultsController.sections {
            return sections.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kGHLItemCell", for: indexPath)
        self.configureCell(cell, at: indexPath)
        return cell
    }
}
