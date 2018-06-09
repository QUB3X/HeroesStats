//
//  HeroDetailsVC.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 04/06/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit

class HeroDetailVC: UITableViewController {

    var hero: Hero? {
        didSet {
            refreshUI()
        }
    }
    
    private var appDelegate: AppDelegate!    
    
    // Stats
    @IBOutlet weak var gamesPlayedLabel: UILabel!
    @IBOutlet weak var gamesBannedLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var winrateLabel: UILabel!
    @IBOutlet weak var deltaWinrateLabel: UILabel!

    // Buttons in table
    @IBOutlet weak var talentsCell: UITableViewCell!
    @IBOutlet weak var matchupsCell: UITableViewCell!
    @IBOutlet weak var mapWinrateCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let talentsTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showTalents))
        let matchupsTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showMatchups))
        let mapWinrateTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showMapWinrate))

        self.talentsCell.addGestureRecognizer(talentsTapGesture)
        self.matchupsCell.addGestureRecognizer(matchupsTapGesture)
        self.mapWinrateCell.addGestureRecognizer(mapWinrateTapGesture)

        // Add Big Titles
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        self.title = "Loading"
    }
    
    // Update data
    func refreshUI() {
        
        loadViewIfNeeded()
        
        if let _hero = self.hero {
            self.title = _hero.name
            
            self.gamesPlayedLabel.text = "\(_hero.gamesPlayed)"
            self.gamesBannedLabel.text = "\(_hero.gamesBanned)"
            self.popularityLabel.text = "\(_hero.popularity)"
            self.winrateLabel.text = "\(_hero.winrate)"
            self.deltaWinrateLabel.text = "∆\(_hero.deltaWinrate)%"
        }
    }
    
    // Click on talents
    @objc func showTalents() {
        performSegue(withIdentifier: "showTalents", sender: self)
    }
    @objc func showMatchups() {
        performSegue(withIdentifier: "showMatchups", sender: self)
    }
    @objc func showMapWinrate() {
        performSegue(withIdentifier: "showMapWinrate", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTalents" {
            if let heroTalentsVC = segue.destination as? HeroTalentsVC,
                let heroName = self.hero?.name {
                getHero(heroName: parseHeroName(name: heroName), completion: {
                    heroDetails in
                    heroTalentsVC.talents = heroDetails.talents
                    heroTalentsVC.tableView.reloadData()
                })
            }
        }
        if segue.identifier == "showMatchups" {
            if let heroMatchupsVC = segue.destination as? HeroMatchupsVC,
                let heroName = self.hero?.name {
                getHero(heroName: parseHeroName(name: heroName), completion: {
                    heroDetails in
                    heroMatchupsVC.heroes = heroDetails.matchups
                    heroMatchupsVC.tableView.reloadData()
                })
            }
        }
    }
}

extension HeroDetailVC: HeroSelectionDelegate {
    func heroSelected(_ newHero: Hero) {
        hero = newHero
    }
}
