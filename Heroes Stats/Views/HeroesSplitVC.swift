//
//  HeroesSplitVC.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 06/06/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit

class HeroesSplitVC: UISplitViewController, UISplitViewControllerDelegate {

    var heroMaster: HeroesListVC?
    var heroDetail: HeroDetailsVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.preferredDisplayMode = .allVisible
        
        self.heroMaster = (childViewControllers.first as! UINavigationController).topViewController as? HeroesListVC
        self.heroDetail = childViewControllers.last as? HeroDetailsVC
        
        getHeroes(completion: {
            heroes in
            
            self.heroMaster!.heroes = heroes
            self.heroDetail!.hero = heroes.first
            
            self.heroMaster!.tableView.reloadData()
        })
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
}
