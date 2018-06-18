//
//  Cache.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 04/06/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import Foundation
import UIKit

class TalentImage {
    
    
    let heroName: String!
    let talentName: String!
    
    init(talent: String, hero: String) {
        heroName = hero
            .lowercased()
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: "zul'jin", with: "zuljin")
            .replacingOccurrences(of: "kel'thuzad", with: "kel-thuzad")
            .replacingOccurrences(of: "deckard", with: "deckard-cain")
            .replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: ":", with: "-")
            .replacingOccurrences(of: " ", with: "-")
            .replacingOccurrences(of: "ú", with: "u")
        talentName = talent
            .lowercased()
            .replacingOccurrences(of: ".", with: "-")
            .replacingOccurrences(of: "zul'jin", with: "zuljin")
            .replacingOccurrences(of: "kel'thuzad", with: "kel-thuzad")
            .replacingOccurrences(of: "'", with: "")
            .replacingOccurrences(of: ":", with: "")
            .replacingOccurrences(of: " ", with: "-")
            .replacingOccurrences(of: "!", with: "")
            .replacingOccurrences(of: "ú", with: "u")
            .replacingOccurrences(of: "(Lvl 20)", with: "")
    }
    
    func searchMatchingImage() -> UIImage {
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("talents/\(heroName!)/\(heroName!)-\(talentName!).jpg")
            if let image = UIImage(contentsOfFile: imageURL.path) {
                return image
            }
        }
        return UIImage(named: "Missing")!
    }
}
