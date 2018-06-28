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
import DropDown

class PlayerHeroesVC: UITableViewController {
    
    var heroes: [Hero] = []
    var filtered: [Hero] = []
    var isFilterActive = false
    
    var dropdown: DropDown?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title
        self.title = "Heroes"
        self.navigationController?.navigationBar.topItem?.title = "Heroes"
        
        // Add search controller
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self as? UISearchResultsUpdating
        // Setup the Search Controller
        search.searchResultsUpdater = self as? UISearchResultsUpdating
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search Heroes"
        definesPresentationContext = true
        // Add Big Titles
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.searchController = search
        
        // Set filter button
        let filterButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.showFilters))
        navigationItem.rightBarButtonItem = filterButton
        
        dropdown = DropDown()
        dropdown?.anchorView = filterButton
        dropdown?.dataSource = ["Sort by Winrate", "Sort by Name"]
        dropdown?.selectionAction = { [unowned self] (index: Int, item: String) in
            self.sortTableBy(index: index)
        }
        
    }
    
    // MARK: - Table functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFilterActive ? filtered.count : heroes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "heroCell") as! HeroListCell
        if heroes.count > 0 {
            let hero = isFilterActive ? filtered[indexPath.row] : heroes[indexPath.row]

            cell.heroNameLabel.text = hero.name
            cell.winrateLabel.text = "\(hero.winrate)%"
            cell.heroThumbImage.image = HeroPortrait(hero: hero.name).searchMatchingImage()
            
            // Create a mask
            let maskView = UIImageView()
            maskView.image = UIImage(named: "portrait-mask")
            cell.heroThumbImage.mask = maskView
            // Set position
            maskView.frame = cell.heroThumbImage.bounds
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    // MARK: - Utility
    @objc func showFilters() {
        dropdown?.show()
    }
    
    func sortTableBy(index: Int) {
        switch index {
            
        case 0:
            self.heroes = self.heroes.sorted(by: {$0.winrate > $1.winrate})
        case 1:
            self.heroes = self.heroes.sorted(by: {$0.name < $1.name})
        default:
            // Sort by Winrate
            self.heroes = self.heroes.sorted(by: {$0.winrate > $1.winrate})
        }
        self.tableView.reloadData()
    }
}
