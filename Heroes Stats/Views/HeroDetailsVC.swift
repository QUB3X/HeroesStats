//
//  HeroDetailsVC.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 04/06/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit

class HeroDetailsVC: UITableViewController {

    var hero: Hero!
    
    // Stats
    @IBOutlet weak var gamesPlayedCounter: UILabel!
    @IBOutlet weak var gamesBannedCounter: UILabel!
    @IBOutlet weak var popularityCounter: UILabel!
    @IBOutlet weak var winrateCounter: UILabel!
    
    // Nav
    @IBOutlet var navbarView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title
        self.title = hero.name
        
        self.gamesPlayedCounter.text = String(hero.gamesPlayed ?? 0)
        self.gamesBannedCounter.text = String(hero.gamesBanned ?? 0)
        self.popularityCounter.text = "\(hero.popularity ?? 0)%"
        self.winrateCounter.text = "\(hero.winrate ?? 0)% (Δ\(hero.deltaWinrate ?? 0)%)"
            
        // Add Big Titles
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        getHero(heroName: parseHeroName(name: hero.name), completion: {
            heroDetails in
            
            print(heroDetails.talents)
        })
    }
}
