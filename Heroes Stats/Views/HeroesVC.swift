//
//  SecondViewController.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 28/05/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class HeroesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var heroes: [Hero] = []
    
    var selectedHeroPath: IndexPath?
    
    let IMAGE_URL = "https://blzmedia-a.akamaihd.net/heroes/circleIcons/storm_ui_ingame_heroselect_btn_"
    
    @IBOutlet weak var heroesTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heroesTableView.delegate = self
        heroesTableView.dataSource = self
        
        // Set title
        self.title = "Heroes"
        self.navigationController?.navigationBar.topItem?.title = "Heroes"
        
        // Add Big Titles
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    // MARK: - Table functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "heroCell") as! HeroListCell
        let hero = heroes[indexPath.row]
        // URL friendly image location
        let heroNameImg = parseHeroName(name: hero.name) + ".png"
        // Set hero name
        cell.heroNameLabel.text = hero.name
        
        // Fetch image and set it
        Alamofire.request(IMAGE_URL + heroNameImg).responseImage { response in
            if let image = response.result.value {
                cell.heroThumbImage.image = image.af_imageScaled(to: CGSize(width: 48, height: 48))
                // tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get selected hero
        selectedHeroPath = indexPath
        
        // go to next view
        performSegue(withIdentifier: "showHeroDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHeroDetails" {
            if let vc = segue.destination as? HeroDetailsVC {
                vc.hero = heroes[selectedHeroPath!.row]
            }
        }
    }
    
    
    // Fetch data
    override func viewWillAppear(_ animated: Bool) {
        
        // Deselect row
        if selectedHeroPath != nil {
            heroesTableView.deselectRow(at: selectedHeroPath!, animated: true)
        }
        if self.heroes.isEmpty {
            getHeroes(completion: {
                _heroes in
                self.heroes = _heroes
                self.heroesTableView.reloadData()
            })
        }
    }
}

