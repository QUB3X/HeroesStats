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
    
    private var player: Player?
    
    @IBOutlet weak var playerTableView: UITableView!
    
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
    }
    
}
