//
//  String+DateFormatter.swift
//  MWGitHubList
//
//  Created by Diego Giardinetto on 22/04/17.
//  Copyright © 2017 MinionWorks. All rights reserved.
//

import Foundation

public extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: self)
    }
}
