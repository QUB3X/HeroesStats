//
//  FirstViewController.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 28/05/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit
import SKActivityIndicatorView
import Alamofire
import Zip

class PlayerProfileVC: UITableViewController {

    // mine is "2366006"
    var playerId: String?
    
    var player: Player? {
        didSet {
            refreshUI()
        }
    }
        
    @IBOutlet weak var teamLeagueLabel: UILabel!
    @IBOutlet weak var heroLeagueLabel: UILabel!
    @IBOutlet weak var unrankedDraftLabel: UILabel!
    @IBOutlet weak var quickMatchLabel: UILabel!
    @IBOutlet weak var winrateLabel: UILabel!
    @IBOutlet weak var mvpRateLabel: UILabel!
    @IBOutlet weak var gamesPlayedLabel: UILabel!
    @IBOutlet weak var timePlayedLabel: UILabel!
    
    @IBOutlet weak var heroesCell: UITableViewCell!
    @IBOutlet weak var mapWinrateCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        // Add Big Titles
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // If it's the first time user log in, show welcome page
        showWelcomePage()
        
        if playerId != nil {
            fetchPlayerStats()
        } else if let _playerId = defaults.string(forKey: "playerId") {
            playerId = _playerId
            fetchPlayerStats()
        }
        
        let heroesTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showHeroes))
        let mapWinrateTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showMapWinrate))
        
        self.heroesCell.addGestureRecognizer(heroesTapGesture)
        self.mapWinrateCell.addGestureRecognizer(mapWinrateTapGesture)

    }
    
    func fetchPlayerStats() {
        SKActivityIndicator.show("Loading your stats...", userInteractionStatus: false)
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
    
    // Click on talents
    @objc func showHeroes() {
        performSegue(withIdentifier: "showHeroes", sender: self)
    }
    @objc func showMapWinrate() {
        performSegue(withIdentifier: "showMapWinrate", sender: self)
    }
    
    @IBAction func unwindToPlayer(segue: UIStoryboardSegue) {
        updateTalents()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMapWinrate" {
            if let mapVC = segue.destination as? HeroMapWinrateVC {
                mapVC.maps = player?.maps ?? []
            }
        }
        else if segue.identifier == "showHeroes" {
            if let heroesVC = segue.destination as? HeroListVC {
                heroesVC.heroes = player?.heroes ?? []
            }
        }
    }
    
    // Mark: - Utility // Talents
    func fetchTalents() {
        SKActivityIndicator.show("Downloading talents...")
        
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        
        Alamofire.download(TALENTS_URL, to: destination).response { response in
            print(response)
            
            if let talentsPath = response.destinationURL {
                let documentsDirectory = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)[0]
                
                do {
                    try Zip.unzipFile(talentsPath, destination: documentsDirectory, overwrite: true, password: nil, progress: {
                        progress in
                        print(progress)
                        
                        if progress == 1 {
                            SKActivityIndicator.dismiss()
                        }
                    })
                } catch {
                    SKActivityIndicator.dismiss()
                    print(error)
                }
            }
        }
    }

    func updateTalents() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("talents.zip") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                // File available
                // TODO: - Check for new releases
                print("Talents.zip exist!")
            } else {
                // File not available
                print("Talents.zip doesn't exist, downloading now!")
                fetchTalents()
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
    }
}
