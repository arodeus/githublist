//
//  Date+DateFormatter.swift
//  MWGitHubList
//
//  Created by Diego Giardinetto on 22/04/17.
//  Copyright © 2017 MinionWorks. All rights reserved.
//

import Foundation

public extension Date {
    func toString(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}
