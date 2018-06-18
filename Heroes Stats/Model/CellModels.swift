//
//  HeroListCell.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 31/05/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit

class HeroListCell: UITableViewCell {
    
    // Left side
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var heroThumbImage: UIImageView!
    
    // Right side
    @IBOutlet weak var winrateLabel: UILabel!
    @IBOutlet weak var deltaWinrateLabel: UILabel!
    @IBOutlet weak var winrateIndicator: UIImageView!
    
    func formatDeltaWinrate(_ winrate: Float) -> String {
        
        let images = ["positive", "positive-plus", "negative", "negative-plus"]
        
        if winrate > 0 {
            if winrate > 1.0 {
                winrateIndicator.image = UIImage(named: "winrate-" + images[1])?.withRenderingMode(.alwaysTemplate)
            } else {
                winrateIndicator.image = UIImage(named: "winrate-" + images[0])?.withRenderingMode(.alwaysTemplate)
            }
            deltaWinrateLabel.textColor = UIColor.Accent.Green.normal
            winrateIndicator.tintColor = UIColor.Accent.Green.normal
            return "+\(winrate)%"
        } else if winrate < 0 {
            if winrate < -1.0 {
                winrateIndicator.image = UIImage(named: "winrate-" + images[3])?.withRenderingMode(.alwaysTemplate)
            } else {
                winrateIndicator.image = UIImage(named: "winrate-" + images[2])?.withRenderingMode(.alwaysTemplate)
            }
            deltaWinrateLabel.textColor = UIColor.Accent.Red.normal
            winrateIndicator.tintColor = UIColor.Accent.Red.normal
            let newWinrate = "\(winrate)%"
            return newWinrate.replacingOccurrences(of: "-", with: "−")
        }
        return "\(winrate)%"
    }
}

class TalentCell: UITableViewCell {
    @IBOutlet weak var talentName: UILabel!
    @IBOutlet weak var talentImage: UIImageView!
    
}
