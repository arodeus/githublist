//
//  ViewController+DataManipulation.swift
//  MWGitHubList
//
//  Created by Diego Giardinetto on 22/04/17.
//  Copyright © 2017 MinionWorks. All rights reserved.
//

import UIKit

extension ViewController {
    @IBAction func getMoreItems(sender: UIBarButtonItem?) {
        self.loadItems(onlyLocalIfExists: false)
    }
    
    func getMoreItemsFromRefreshControl() {
        self.loadItems(onlyLocalIfExists: false)
    }
    
    /// Perform item loading, both online and local
    ///
    /// - Parameter onlyLocalIfExists: at application first run, if local database exists, use it instead of search online
    func loadItems(onlyLocalIfExists: Bool = true) {
        var nextPage: Int = 1
        let _managerProperties = GHLDownloadManager.sharedInstance.managerProperties
        if _managerProperties.count > 0 {
            if onlyLocalIfExists {
                return
            }
            
            if let _nextPage = _managerProperties["next_page"] as? NSNumber {
                nextPage = _nextPage.intValue
            }
        }
        
        self.performItemsDownloadOperation(fromPage: nextPage)
    }
    
    func updateTitleLabel() {
        var titleToShow = "Java Developers"
        let totalItemCount = GHLDownloadManager.sharedInstance.totalItems()
        if totalItemCount > 0 {
            if let sections = self.fetchedResultsController.sections {
                let sectionItemCount = sections[0].numberOfObjects
                titleToShow += " " + "[\(sectionItemCount) of \(totalItemCount)]"
                
                // NOTE: updating last loading page completed successfully
                let calculatedPage = sectionItemCount/kPageSize
                let remainder = sectionItemCount % kPageSize
                if remainder != 0 {
                    GHLDownloadManager.sharedInstance.managerProperties["next_page"] = NSNumber(value: calculatedPage)
                } else {
                    GHLDownloadManager.sharedInstance.managerProperties["next_page"] = NSNumber(value:( calculatedPage + 1))
                }
                
                GHLDownloadManager.sharedInstance.saveDownloadManagerProperties()
            }
        }
        
        
        self.lblItemCount.text = titleToShow
    }
    
    func showDownloadError() {
        if self.hasError { return }
        self.refreshControl.endRefreshing()
        
        self.hasError = true
        let message = "It was not possible to complete your request. Please try again later."
        let acAlert = UIAlertController(title: "Sorry!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (alertAction) in
            self.hasError = false
        }
        
        acAlert.addAction(cancelAction)
        self.present(acAlert, animated: true, completion: nil)
    }
    
    /// search for users that have Java repos
    ///
    /// - Parameter page: starting page, default: 1
    func performItemsDownloadOperation(fromPage page: Int = 1) {
        if let _operationQueue = GHLDownloadManager.sharedInstance.operationQueue {
            _operationQueue.addOperation({
                // NOTE: searching for users that have Java repos
                if let searchURL = URL(string: "https://api.github.com/search/users?q=language:java&per_page=\(kPageSize)&page=\(page)") {
                    let searchURLRequest = URLRequest(url: searchURL)
                    let task = URLSession.shared.dataTask(with: searchURLRequest, completionHandler: { (taskData, taskURLResponse, taskError) in
                        
                        if let _requestError = taskError {
                            print(_requestError.localizedDescription)
                            DispatchQueue.main.async {
                                self.showDownloadError()
                            }
                            return
                        }
                        
                        if let _urlResponse = taskURLResponse as? HTTPURLResponse {
                            if _urlResponse.statusCode != 200 {
                                print("> [DEBUG] response with status code \(_urlResponse.statusCode)")
                                DispatchQueue.main.async {
                                    self.showDownloadError()
                                }
                                return
                            }
                        }
                        
                        do {
                            if let _data = taskData {
                                let jsonObject = try JSON(data: _data)
                                
                                // NOTE: update manager properties to recover status from last run
                                GHLDownloadManager.sharedInstance.managerProperties["total_count"] = jsonObject["total_count"].numberValue
                                GHLDownloadManager.sharedInstance.saveDownloadManagerProperties()
                                
                                // NOTE: place operations to download user details
                                for item in jsonObject["items"].arrayValue {
                                    self.performItemDetailsDownloadOperation(withItemName: item["login"].stringValue)
                                }
                            }
                        } catch let jsonError {
                            print(jsonError.localizedDescription)
                        }
                    })
                    task.resume()
                }
            })
        }
    }
    
    /// Download github user details
    ///
    /// - Parameter name: github username
    func performItemDetailsDownloadOperation(withItemName name: String) {
        if name.isEmpty {
            print("> [DEBUG] invalid item name: <empty>")
            return
        }
        
        if let _operationQueue = GHLDownloadManager.sharedInstance.operationQueue {
            _operationQueue.addOperation {
                if let itemDetailsURL = URL(string: "https://api.github.com/users/\(name)") {
                    let itemDetailsURLRequest = URLRequest(url: itemDetailsURL)
                    let task = URLSession.shared.dataTask(with: itemDetailsURLRequest, completionHandler: { (taskData, taskURLResponse, taskError) in
                        
                        if let _requestError = taskError {
                            print(_requestError.localizedDescription)
                            DispatchQueue.main.async {
                                self.showDownloadError()
                            }
                            return
                        }
                        
                        if let _urlResponse = taskURLResponse as? HTTPURLResponse {
                            if _urlResponse.statusCode != 200 {
                                DispatchQueue.main.async {
                                    self.showDownloadError()
                                }
                                return
                            }
                        }
                        
                        do {
                            if let _data = taskData {
                                let jsonObject = try JSON(data: _data)
                                GHLDownloadManager.sharedInstance.saveItemDetails(details: jsonObject, withContext: self.managedObjectContext)
                            }
                        } catch let jsonError {
                            print(jsonError.localizedDescription)
                        }
                    })
                    task.resume()
                }
            }
        }
    }
}
