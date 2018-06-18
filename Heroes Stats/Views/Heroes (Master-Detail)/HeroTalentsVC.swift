//
//  HeroTalentsVC.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 07/06/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Zip
import SKActivityIndicatorView

class HeroTalentsVC: UITableViewController {
    
    var heroName: String?
    var hero: HeroDetails? {
        didSet {
            talents = hero!.talents
            tableView.reloadData()
        }
    }
    
    let talentsTiers = [
        0: "LV 1",
        1: "LV 4",
        2: "LV 7",
        3: "Heroic Talents",
        4: "LV 13",
        5: "LV 16",
        6: "Storm Talents"
    ]
    
    private var talents: [[Talent]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Talents"
        
        // Add Big Titles
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        updateTalents()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return talents.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return talents[section].count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return talentsTiers[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "talentCell", for: indexPath) as! TalentCell
        
        let talent = talents[indexPath.section][indexPath.row]
        cell.talentName.text = talent.name
        
        cell.talentImage.image = TalentImage(talent: talent.name, hero: heroName!).searchMatchingImage()
        
        return cell
    }
    
    // Mark: - Utility // Talents
    func fetchTalents() {
        
        SKActivityIndicator.show("Downloading talents...")
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("talents.zip") as URL
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
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
                            self.tableView.reloadData()
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
