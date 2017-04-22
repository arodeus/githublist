//
//  ViewController+NSFetchedResultsControllerDelegate.swift
//  MWGitHubList
//
//  Created by Diego Giardinetto on 22/04/17.
//  Copyright © 2017 MinionWorks. All rights reserved.
//

import UIKit
import CoreData

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.itemTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.itemTableView.endUpdates()
        self.refreshControl.endRefreshing()
        self.updateTitleLabel()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("> [DEBUG] updating object at", indexPath ?? "<EMPTY>")
        
        switch type {
        case .update:
            if let _indexPath = indexPath {
                if let cell = self.itemTableView.cellForRow(at: _indexPath) {
                    self.configureCell(cell, at: _indexPath)
                }
            }
            break
        case .insert:
            if let _indexPath = newIndexPath {
                self.itemTableView.insertRows(at: [_indexPath], with: UITableViewRowAnimation.fade)
            }
            break
        default:
            print("> [DEBUG] action not configured")
        }
    }
}
