//
//  HeroMatchupsVC.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 07/06/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit

class HeroMatchupsVC: UITableViewController {

    var heroes: [Hero] = [] {
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
        return heroes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchupCell", for: indexPath) as! HeroMatchupCell
        let hero = heroes[indexPath.row]
        
        // Set hero name
        cell.heroNameLabel.text = hero.name
        
        // Set winrates
        cell.winrateLabel.text = "\(hero.winrate)%"
        
        cell.heroThumbImage.image = HeroPortrait(hero: hero.name).searchMatchingImage()
        
        // Create a mask
        let maskView = UIImageView()
        maskView.image = UIImage(named: "portrait-mask")
        cell.heroThumbImage.mask = maskView
        // Set position
        maskView.frame = cell.heroThumbImage.bounds

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
}
