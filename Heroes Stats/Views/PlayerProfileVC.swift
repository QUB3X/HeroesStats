//
//  FirstViewController.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 28/05/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit

class PlayerProfileVC: UITableViewController {

    var playerId = "2366006"
    
    var player: Player?
    
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
        
        // Add Big Titles
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        getPlayer(playerId: playerId, completion: {
            _player in
            
            self.player = _player
            self.updateView()
        })
    }
    
    func updateView() {
        // Data that get fetched asynchronously
        
        // Set title
        self.title = self.player?.playerName ?? "Player"
        self.navigationController?.navigationBar.topItem?.title = self.player?.playerName ?? "Player"
        self.teamLeagueLabel.text = player?.teamLeague
        self.heroLeagueLabel.text = player?.heroLeague
        self.unrankedDraftLabel.text = player?.unrankedDraft
        self.quickMatchLabel.text = player?.quickMatch
        self.winrateLabel.text = "\(player?.winrate ?? 0)"
        self.mvpRateLabel.text = "\(player?.MVPrate ?? 0)"
        self.gamesPlayedLabel.text = "\(player?.gamesPlayed ?? 0)"
        self.timePlayedLabel.text = player?.timePlayed
    }
}
