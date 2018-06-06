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

class HeroesListVC: UITableViewController {
    
    var heroes: [Hero] = []
    
    var selectedHeroPath: IndexPath?
    
    let IMAGE_URL = "https://blzmedia-a.akamaihd.net/heroes/circleIcons/storm_ui_ingame_heroselect_btn_"
   
    
    // Fetch data
    override func viewWillAppear(_ animated: Bool) {
        
        // Deselect row
        if selectedHeroPath != nil {
            self.tableView.deselectRow(at: selectedHeroPath!, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parentVC = self.splitViewController as! HeroesSplitVC
        parentVC.heroMaster = self
        
        // Set title
        self.title = "Heroes"
        self.navigationController?.navigationBar.topItem?.title = "Heroes"
        
        // Add Big Titles
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    // MARK: - Table functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "heroCell") as! HeroListCell
        if heroes.count > 0 {
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
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get selected hero
        selectedHeroPath = indexPath
        let selectedHero = heroes[indexPath.row]
        // go to next view
        
        if let parent = self.splitViewController as? HeroesSplitVC {
            // Pass hero data to detail view
            parent.heroDetail?.hero = selectedHero
            // Refresh the view
            parent.heroDetail?.updateView()
            // Show the hero page
            showDetailViewController(parent.heroDetail!, sender: self)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
}

