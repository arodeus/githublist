//
//  GHLDownloadManager.swift
//  MWGitHubList
//
//  Created by Diego Giardinetto on 22/04/17.
//  Copyright © 2017 MinionWorks. All rights reserved.
//

import UIKit
import CoreData

class GHLDownloadManager: NSObject {
    static let sharedInstance = GHLDownloadManager()
    var operationQueue: OperationQueue?
    
    var managerProperties = [String:Any]()
    
    // NOTE: prevent use of init() for singleton with private modifier
    private override init() {
        print("GHLDownloadManager:init")
        
        if self.operationQueue == nil {
            print("GHLDownloadManager -> creating operation queue")
            self.operationQueue = OperationQueue()
            self.operationQueue?.maxConcurrentOperationCount = 1
        }
    }
    
    func numberOfOperations() -> Int {
        guard let _opq = self.operationQueue else { return 0 }
        return _opq.operationCount
    }
    
    func saveItemDetails(details: JSON, withContext context: NSManagedObjectContext) {
        /*
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        context.persistentStoreCoordinator = appDelegate.persistentContainer.persistentStoreCoordinator
        context.undoManager = nil
        */
        
        context.performAndWait {
            print(details["login"].stringValue)
            
            // save/update item here
            let predicate = NSPredicate(format: "itemID == %@", argumentArray: [details["id"].stringValue])
            let theRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GHLItemDetails")
            theRequest.predicate = predicate
            theRequest.fetchLimit = 1
            
            do {
                let updatedItem: GHLItemDetails
                let resultSet = try context.fetch(theRequest) as! [GHLItemDetails]
                if resultSet.count <= 0 {
                    print("> [DEBUG] saving new item with name: \(details["login"].stringValue)")
                    updatedItem = NSEntityDescription.insertNewObject(forEntityName: "GHLItemDetails", into: context) as! GHLItemDetails
                } else {
                    print("> [DEBUG] updating item with name: \(resultSet[0].login)")
                    updatedItem = resultSet[0]
                }
                
                updatedItem.itemID = details["id"].numberValue
                updatedItem.login = details["login"].stringValue
                
                updatedItem.email = details["email"].string
                updatedItem.avatarURL = details["avatar_url"].string
                updatedItem.gravatarID = details["gravatar_id"].string
                
                updatedItem.name = details["name"].string
                updatedItem.createdAt = details["created_at"].stringValue.toDate()
                
                try context.save()
                
            } catch let contextError {
                print(contextError.localizedDescription)
            }
            
        }
    }
}
