//
//  HeroDetailsVC.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 04/06/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit
import SKActivityIndicatorView

class HeroDetailVC: UITableViewController, ErrorMessageRenderer {

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
        navigationController?.navigationBar.prefersLargeTitles = true
        
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
        if hero != nil {
            SKActivityIndicator.show()
            getHero(heroName: hero!.name, completion: {
                _hero in
                SKActivityIndicator.dismiss()
                switch segue.identifier {
                case "showTalents":
                    print("-> Talents")
                    if let talentVC = segue.destination as? HeroTalentsVC {
                        talentVC.heroName = self.hero!.name
                        talentVC.hero = _hero
                    }
                case "showMatchups":
                    print("-> Matchups")
                    if let matchupsVC = segue.destination as? HeroMatchupsVC {
                        matchupsVC.heroes = _hero.matchups
                    }
                case "showMapWinrate":
                    print("-> Map Winrate")
                    if let mapsVC = segue.destination as? HeroMapWinrateVC {
                        mapsVC.maps = _hero.mapWinrate
                    }
                    break
                default:
                    break
                }
            })
        }
    }
}

extension HeroDetailVC: HeroSelectionDelegate {
    func heroSelected(_ newHero: Hero) {
        hero = newHero
    }
}
