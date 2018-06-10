//
//  HeroTalentsVC.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 07/06/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit

class HeroTalentsVC: UITableViewController {

    var hero: HeroDetails? {
        didSet {
            talents = hero!.talents
            tableView.reloadData()
        }
    }
    
    private var talents: [[Talent]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Talents"
        
        // Add Big Titles
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return talents.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return talents[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tier \(section + 1)"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "talentCell", for: indexPath) as! TalentCell
        cell.talentName.text = talents[indexPath.section][indexPath.row].name
        
        return cell
    }
}
