//
//  GHLDownloadManager.swift
//  MWGitHubList
//
//  Created by Diego Giardinetto on 22/04/17.
//  Copyright © 2017 MinionWorks. All rights reserved.
//

import UIKit
import CoreData

/// Manage download operations and local storage
class GHLDownloadManager: NSObject {
    static let sharedInstance = GHLDownloadManager()
    // var operationQueue: OperationQueue?
    
    var managerProperties = [String:Any]()
    
    // NOTE: prevent use of init() for singleton with private modifier
    private override init() {
        // self.operationQueue = OperationQueue()
        // self.operationQueue?.maxConcurrentOperationCount = 1
    }
    
    func totalItems() -> Int {
        if let _totalCount = self.managerProperties["total_count"] as? NSNumber {
            return _totalCount.intValue
        }
        
        return -1
    }
    
    func saveItemDetails(details: JSON, withContext context: NSManagedObjectContext) {
        context.performAndWait {
            // save/update item
            let predicate = NSPredicate(format: "itemID == %@", argumentArray: [details["id"].stringValue])
            let theRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GHLItemDetails")
            theRequest.predicate = predicate
            theRequest.fetchLimit = 1
            
            do {
                let updatedItem: GHLItemDetails
                let resultSet = try context.fetch(theRequest) as! [GHLItemDetails]
                if resultSet.count <= 0 {
                    updatedItem = NSEntityDescription.insertNewObject(forEntityName: "GHLItemDetails", into: context) as! GHLItemDetails
                } else {
                    updatedItem = resultSet[0]
                }
                
                updatedItem.itemID = details["id"].numberValue
                updatedItem.login = details["login"].stringValue
                updatedItem.sortableLogin = details["login"].stringValue.lowercased()
                
                updatedItem.email = details["email"].string
                updatedItem.avatarURL = details["avatar_url"].string
                updatedItem.gravatarID = details["gravatar_id"].string
                
                updatedItem.name = details["name"].string
                updatedItem.createdAt = details["created_at"].stringValue.toDate()
                
                updatedItem.publicRepos = details["public_repos"].numberValue
                updatedItem.publicGists = details["public_gists"].numberValue
                updatedItem.followers = details["followers"].numberValue
                updatedItem.following = details["following"].numberValue
                
                updatedItem.bio = details["bio"].string
                
                try context.save()
                
            } catch let contextError {
                print(contextError.localizedDescription)
            }
            
        }
    }
}
