//
//  GHLDownloadManager+FileManagement.swift
//  MWGitHubList
//
//  Created by Diego Giardinetto on 22/04/17.
//  Copyright © 2017 MinionWorks. All rights reserved.
//

import Foundation

extension GHLDownloadManager {
    func getDirectoryPath(withFolder directoryKey: String? = nil, shouldCreateDirectory: Bool = false) -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        
        guard let _directoryKey = directoryKey else {
            print("> [DEBUG] Using Document directory...")
            return documentDirectory
        }
        
        let pathToReturn = documentDirectory + "/" + _directoryKey
        if !FileManager.default.fileExists(atPath: pathToReturn) {
            if shouldCreateDirectory {
                do {
                    try FileManager.default.createDirectory(atPath: pathToReturn, withIntermediateDirectories: true, attributes: nil)
                } catch let createDirectoryError {
                    print(createDirectoryError.localizedDescription)
                }
            } else {
                print("> [DEBUG] directory not found! Using Document directory...")
                return documentDirectory
            }
        }
        
        return pathToReturn
    }
    
    func loadDownloadManagerProperties() {
        let propertiesPath = self.getDirectoryPath() + "/" + "MWGitHutList.plist"
        if FileManager.default.fileExists(atPath: propertiesPath) {
            if let _dict = NSDictionary(contentsOfFile: propertiesPath) as? [String:Any] {
                print("> [DEBUG]: ", _dict)
                self.managerProperties = _dict
            }
        }
    }
    
    func saveDownloadManagerProperties() {
        do {
            let propertiesPath = self.getDirectoryPath() + "/" + "MWGitHutList.plist"
            if FileManager.default.fileExists(atPath: propertiesPath) {
                try FileManager.default.removeItem(atPath: propertiesPath)
            }
            
            (self.managerProperties as NSDictionary).write(toFile: propertiesPath, atomically: true)
        } catch let fmError {
            print(fmError.localizedDescription)
        }
    }
    
    func lastDownloadedPage() -> Int {
        return 0
    }
}
