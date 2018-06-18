//
//  FirstViewController.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 28/05/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit
import SKActivityIndicatorView

class PlayerProfileVC: UITableViewController {

    // mine is "2366006"
    var playerId: String?
    
    var player: Player? {
        didSet {
            refreshUI()
        }
    }
    
    @IBOutlet weak var playerTableView: UITableView!
    
    @IBOutlet weak var teamLeagueLabel: UILabel!
    @IBOutlet weak var heroLeagueLabel: UILabel!
    @IBOutlet weak var unrankedDraftLabel: UILabel!
    @IBOutlet weak var quickMatchLabel: UILabel!
    @IBOutlet weak var winrateLabel: UILabel!
    @IBOutlet weak var mvpRateLabel: UILabel!
    @IBOutlet weak var gamesPlayedLabel: UILabel!
    @IBOutlet weak var timePlayedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        // Add Big Titles
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        // If it's the first time user log in, show welcome page
        showWelcomePage()
        
        if playerId != nil {
            fetchPlayerStats()
        } else if let _playerId = defaults.string(forKey: "playerId") {
            playerId = _playerId
            fetchPlayerStats()
        }
    }
    
    func fetchPlayerStats() {
        SKActivityIndicator.show("Loading your stats...")
        getPlayer(playerId: playerId!, completion: {
            _player in
            
            self.player = _player
            
            self.refreshUI()
        })
    }
    
    func refreshUI() {
        SKActivityIndicator.dismiss()
        // Data that get fetched asynchronously
        if let _player = self.player {
            // Set title
            self.title = _player.playerName
            self.navigationController?.navigationBar.topItem?.title = _player.playerName
            self.teamLeagueLabel.text = _player.teamLeague
            self.heroLeagueLabel.text = _player.heroLeague
            self.unrankedDraftLabel.text = _player.unrankedDraft
            self.quickMatchLabel.text = _player.quickMatch
            self.winrateLabel.text = "\(_player.winrate)"
            self.mvpRateLabel.text = "\(_player.MVPrate)"
            self.gamesPlayedLabel.text = "\(_player.gamesPlayed)"
            self.timePlayedLabel.text = _player.timePlayed
        }
    }
    
    func showWelcomePage() {
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "isFirstOpen") {
            self.performSegue(withIdentifier: "showWelcomePage", sender: self)
        }
    }
    
    @IBAction func unwindToPlayer(segue: UIStoryboardSegue) {
        fetchPlayerStats()
    }
}
