//
//  HeroMapWinrateVC.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 18/06/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit

class HeroMapWinrateVC: UITableViewController, ErrorMessageRenderer {

    var maps : [Map] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maps.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapWinrateCell", for: indexPath) as! MapWinrateCell
        let map = maps[indexPath.row]
        cell.mapNameLabel.text = map.name
        cell.winrateLabel.text = "\(map.winrate ?? 0)%"
        cell.gamesPlayedLabel.text = "\(map.gamesPlayed ?? 0)"
        
        let mapName = map.name.lowercased().replacingOccurrences(of: " ", with: "-")
        
        cell.mapImageView.image = UIImage(named: mapName)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
}
