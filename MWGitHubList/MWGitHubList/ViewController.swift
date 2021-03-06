//
//  ViewController.swift
//  MWGitHubList
//
//  Created by Diego Giardinetto on 21/04/17.
//  Copyright © 2017 MinionWorks. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet var lblItemCount: UILabel!
    @IBOutlet var itemTableView: UITableView!
    
    var hasError = false
    var refreshControl = UIRefreshControl()
    var managedObjectContext: NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GHLItemDetails")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "sortableLogin", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 10
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.barTintColor = UIColor.groupTableViewBackground
        self.itemTableView.tableFooterView = UIView()
        
        // NOTE: adding pull to refresh management
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.tintColor = UIColor.black
        self.refreshControl.backgroundColor = UIColor.white
        self.refreshControl.addTarget(self, action: #selector(getMoreItemsFromRefreshControl), for: UIControlEvents.valueChanged)
        self.itemTableView.addSubview(refreshControl)
        
        // NOTE: loading data from CoreData store if any
        do {
            try self.fetchedResultsController.performFetch()
        } catch let fetchError {
            print(fetchError.localizedDescription)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateTitleLabel()
        self.loadItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

