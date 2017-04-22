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
        
        if let _createdAt = item.createdAt {
            cell.detailTextLabel?.text = "created: \(_createdAt.toString())"
        } else {
            cell.detailTextLabel?.text = "creation date not available"
        }
        
        if let _avatarURLString = item.avatarURL {
            let imageURL = URL(string: _avatarURLString)
            cell.imageView?.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "no_image_350x350"))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GHLUserDetailsViewController") as! GHLUserDetailsViewController
        vc.currentItemDetails = self.fetchedResultsController.object(at: indexPath) as! GHLItemDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101.0
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
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.imageView?.image = nil
        cell.textLabel?.text = nil
        cell.detailTextLabel?.text = nil
    }
}
