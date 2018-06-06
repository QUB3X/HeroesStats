//
//  HeroDetailsVC.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 04/06/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit

class HeroDetailsVC: UITableViewController {

    var hero: Hero?
    
    // Stats
    @IBOutlet weak var gamesPlayedLabel: UILabel!
    @IBOutlet weak var gamesBannedLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var winrateLabel: UILabel!
    @IBOutlet weak var deltaWinrateLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parentVC = self.splitViewController as! HeroesSplitVC
        parentVC.heroDetail = self
        
        updateView()
    }
    
    func updateView() {
        // Set title
        self.title = hero?.name ?? "Hero"
        
        self.gamesPlayedLabel.text = String(hero?.gamesPlayed ?? 0)
        self.gamesBannedLabel.text = String(hero?.gamesBanned ?? 0)
        self.popularityLabel.text = "\(hero?.popularity ?? 0)%"
        self.winrateLabel.text = "\(hero?.winrate ?? 0)"
        self.deltaWinrateLabel.text = "% (Δ\(hero?.deltaWinrate ?? 0)%)"
        
        // Add Big Titles
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        if hero != nil {
            getHero(heroName: parseHeroName(name: hero!.name), completion: {
                heroDetails in
            })
        }
    }
}
