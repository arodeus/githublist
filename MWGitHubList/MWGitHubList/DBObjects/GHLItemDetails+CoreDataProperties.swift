//
//  GHLItemDetails+CoreDataProperties.swift
//  MWGitHubList
//
//  Created by Diego Giardinetto on 22/04/17.
//  Copyright © 2017 MinionWorks. All rights reserved.
//

import Foundation
import CoreData

extension GHLItemDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GHLItemDetails> {
        return NSFetchRequest<GHLItemDetails>(entityName: "GHLItemDetails")
    }

    @NSManaged public var itemID: NSNumber
    @NSManaged public var login: String
    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var email: String?
    @NSManaged public var gravatarID: String?
    @NSManaged public var avatarURL: String?
    @NSManaged public var publicGists: NSNumber
    @NSManaged public var followers: NSNumber
    @NSManaged public var following: NSNumber
    @NSManaged public var bio: String?
    @NSManaged public var itemType: String?
    @NSManaged public var publicRepos: NSNumber
    @NSManaged public var company: String?

}
