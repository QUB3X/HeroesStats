//
//  HeroesSplitVC.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 06/06/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit

class PatchSplitVC: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = .allVisible
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
