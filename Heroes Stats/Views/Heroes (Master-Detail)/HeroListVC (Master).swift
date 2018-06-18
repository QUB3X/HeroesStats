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
import SKActivityIndicatorView

protocol HeroSelectionDelegate: class {
    func heroSelected(_ newHero: Hero)
}

class HeroListVC: UITableViewController {
    
    let IMAGE_URL = "https://blzmedia-a.akamaihd.net/heroes/circleIcons/storm_ui_ingame_heroselect_btn_"
    
    var heroes: [Hero] = []
    var selectedHeroPath: IndexPath?
    
    
    weak var delegate: HeroSelectionDelegate?
    private var appDelegate: AppDelegate!
    
   
    // Fetch data
    func fetchData() {
        // Fetch data
        SKActivityIndicator.show("Loading heroes...")
        getHeroes(completion: {
            _heroes in
            
            SKActivityIndicator.dismiss()
            // Save and update data
            self.heroes = _heroes as [Hero]
            self.updateData()

            // Load first hero data
            self.delegate?.heroSelected(self.heroes.first!)
        })
    }
    
    // Update data
    func updateData() {
        tableView.reloadData()
    }
    
    // Fetch data
    override func viewWillAppear(_ animated: Bool) {
        // Deselect row
        if selectedHeroPath != nil {
            self.tableView.deselectRow(at: selectedHeroPath!, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if heroes.isEmpty {
            fetchData()
        }
        
        // Set title
        self.title = "Heroes"
        self.navigationController?.navigationBar.topItem?.title = "Heroes"
        
        // Add Big Titles
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        // Set filter button
        let filterButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.showFilters))
        navigationItem.rightBarButtonItem = filterButton
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
            let heroNameImg = parseHeroName(hero.name) + ".png"
            // Set hero name
            cell.heroNameLabel.text = hero.name
            
            // Set winrates
            cell.winrateLabel.text = "\(hero.winrate)%"
            cell.deltaWinrateLabel.text = cell.formatDeltaWinrate(hero.deltaWinrate)
            
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
        // to deselect row
        self.selectedHeroPath = indexPath
        
        let selectedHero = heroes[indexPath.row]
        delegate?.heroSelected(selectedHero)
        
        if let detailVC = delegate as? HeroDetailVC, let detailNC = detailVC.navigationController {
            splitViewController?.showDetailViewController(detailNC, sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    // MARK: - Utility
    @objc func showFilters() {
        let filterController = UIAlertController(title: "Filters", message: "Choose a sorting method!", preferredStyle: .actionSheet)
        let sortByWinrate = UIAlertAction(title: "Sort by Winrate", style: .default, handler: {_ in
            self.heroes = self.heroes.sorted(by: {$0.winrate > $1.winrate})
            self.tableView.reloadData()
        })
        let sortByDeltaWinrate = UIAlertAction(title: "Sort by Δ Winrate", style: .default, handler: {_ in
            self.heroes = self.heroes.sorted(by: {$0.deltaWinrate == $1.deltaWinrate ? $0.name < $1.name : $0.deltaWinrate > $1.deltaWinrate})
            self.tableView.reloadData()
        })
        let sortByName = UIAlertAction(title: "Sort by Name", style: .default, handler: {_ in
            self.heroes = self.heroes.sorted(by: {$0.name < $1.name})
            self.tableView.reloadData()
        })
        filterController.addAction(sortByWinrate)
        filterController.addAction(sortByDeltaWinrate)
        filterController.addAction(sortByName)
        filterController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            
        present(filterController, animated: true, completion: nil)
    }
}

