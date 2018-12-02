//
//  PatchListVC.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 22/06/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit
import SKActivityIndicatorView

protocol PatchSelectionDelegate: class {
    func patchSelected(_ newPatch: Patch)
}

class PatchListVC: UITableViewController, ErrorMessageRenderer {

    weak var delegate: PatchSelectionDelegate?
    private var appDelegate: AppDelegate!
    
    var isPTR: Bool = false
    
    var livePatches = [Patch]()
    var ptrPatches = [Patch]()
    
    @IBOutlet weak var patchSegControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if livePatches.isEmpty {
            print("Patch is empty, fetching patches...")
            fetchData()
        }
        
        // Set title
        self.title = "Patch Notes"
        self.navigationController?.navigationBar.topItem?.title = "Patch Notes"
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isPTR ? ptrPatches.count : livePatches.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "patchCell", for: indexPath)
        let patch = isPTR ? ptrPatches[indexPath.row] : livePatches[indexPath.row]
        cell.textLabel?.text = patch.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedPatch = isPTR ? ptrPatches[indexPath.row] : livePatches[indexPath.row]
        delegate?.patchSelected(selectedPatch)
        
        if let detailVC = delegate as? PatchDetailVC {
            splitViewController?.showDetailViewController(detailVC, sender: nil)
        }
    }
    
    @IBAction func patchTypeChanged(_ sender: Any) {
        isPTR = patchSegControl.selectedSegmentIndex == 0 ? false : true
        tableView.reloadData()
    }
    
    func fetchData() {
        getPatches(completion: { (patches) in
            for patch in patches {
                if patch.title.contains("PTR") {
                    self.ptrPatches.append(patch)
                } else {
                    self.livePatches.append(patch)
                }
            }
            self.tableView.reloadData()
        })
    }
    
    
}
