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

protocol HeroSelectionDelegate: class {
    func heroSelected(_ newHero: Hero)
}

class HeroListVC: UITableViewController {
    
    let IMAGE_URL = "https://blzmedia-a.akamaihd.net/heroes/circleIcons/storm_ui_ingame_heroselect_btn_"
    
    var heroes: [Hero] = []
    var filtered: [Hero] = []
    var isFilterActive = false
    var selectedHeroPath: IndexPath?
    
    weak var delegate: HeroSelectionDelegate?
    private var appDelegate: AppDelegate!
    
    var dropdown: DropDown?
    
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
        
        // Add search controller
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        // Setup the Search Controller
        search.searchResultsUpdater = self
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
        dropdown?.dataSource = ["Sort by Winrate", "Sort by ∆ Winrate", "Sort by Name", "Sort by Popularity"]
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
            // URL friendly image location
            // Set hero name
            cell.heroNameLabel.text = hero.name
            
            // Set winrates
            cell.winrateLabel.text = "\(hero.winrate)%"
            cell.deltaWinrateLabel.text = formatDeltaWinrate(winrate: hero.deltaWinrate,
                                                             winrateIndicator: cell.winrateIndicator,
                                                             deltaWinrateLabel: cell.deltaWinrateLabel)
            
            cell.heroThumbImage.image = HeroPortrait(hero: hero.name).searchMatchingImage()
            
            // Create a mask
            let maskView = UIImageView()
            maskView.image = UIImage(named: "portrait-mask")
            cell.heroThumbImage.mask = maskView
            // Set position
            maskView.frame = cell.heroThumbImage.bounds
            // Fetch image and set it
            /*
            Alamofire.request(IMAGE_URL + heroNameImg).responseImage { response in
                if let image = response.result.value {
                    cell.heroThumbImage.image = image.af_imageScaled(to: CGSize(width: 48, height: 48))
                    // tableView.reloadRows(at: [indexPath], with: .none)
                }
            }*/
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // to deselect row
        self.selectedHeroPath = indexPath
        
        let selectedHero = isFilterActive ? filtered[indexPath.row] : heroes[indexPath.row]
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
        dropdown?.show()
    }
    
    func sortTableBy(index: Int) {
        switch index {

        case 0:
            self.heroes = self.heroes.sorted(by: {$0.winrate > $1.winrate})
        case 1:
            self.heroes = self.heroes.sorted(by: {$0.deltaWinrate == $1.deltaWinrate ? $0.name < $1.name : $0.deltaWinrate > $1.deltaWinrate})
        case 2:
            self.heroes = self.heroes.sorted(by: {$0.name < $1.name})
        case 3:
            self.heroes = self.heroes.sorted(by: {$0.popularity < $1.popularity})
        default:
            // Sort by Winrate
            self.heroes = self.heroes.sorted(by: {$0.winrate > $1.winrate})
        }
        self.tableView.reloadData()
    }
}

extension HeroListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            self.filtered = self.heroes.filter({
                (hero) -> Bool in
                return hero.name.lowercased().contains(text.lowercased())
            })
            self.isFilterActive = true
        } else {
            self.isFilterActive = false
            self.filtered = [Hero]()
        }
        self.tableView.reloadData()
    }
}
