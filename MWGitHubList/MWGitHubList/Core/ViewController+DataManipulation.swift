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
    
    func loadItems(onlyLocalIfExists: Bool = true) {
        var nextPage: Int = 1
        let _managerProperties = GHLDownloadManager.sharedInstance.managerProperties
        if _managerProperties.count > 0 {
            print(_managerProperties)
            
            if onlyLocalIfExists {
                print("> [DEBUG] load local data first")
                return
            }
            
            if let _nextPage = _managerProperties["next_page"] as? NSNumber {
                nextPage = _nextPage.intValue
            }
        }
        
        print("> [DEBUG] download remote data")
        self.performItemsDownloadOperation(fromPage: nextPage)
    }
    
    func performItemsDownloadOperation(fromPage page: Int) {
        if let _operationQueue = GHLDownloadManager.sharedInstance.operationQueue {
            _operationQueue.addOperation({
                if let searchURL = URL(string: "https://api.github.com/search/users?q=language:java&per_page=10&page=\(page)") {
                    let searchURLRequest = URLRequest(url: searchURL)
                    let task = URLSession.shared.dataTask(with: searchURLRequest, completionHandler: { (taskData, taskURLResponse, taskError) in
                        
                        if let _requestError = taskError {
                            print(_requestError.localizedDescription)
                            // TODO: reload tableview, show error
                            return
                        }
                        
                        if let _urlResponse = taskURLResponse as? HTTPURLResponse {
                            if _urlResponse.statusCode != 200 {
                                print("> [DEBUG] response with status code \(_urlResponse.statusCode)")
                                // TODO: reload tableview, show error
                                return
                            }
                        }
                        
                        do {
                            if let _data = taskData {
                                let jsonObject = try JSON(data: _data)
                                
                                // NOTE: update manager properties to recover status from last run
                                GHLDownloadManager.sharedInstance.managerProperties["total_count"] = jsonObject["total_count"].numberValue
                                GHLDownloadManager.sharedInstance.managerProperties["next_page"] = NSNumber(value: (page + 1))
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
                            return
                        }
                        
                        if let _urlResponse = taskURLResponse as? HTTPURLResponse {
                            if _urlResponse.statusCode != 200 {
                                print("> [DEBUG] response with status code \(_urlResponse.statusCode)")
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
