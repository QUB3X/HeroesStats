//
//  EsportVC.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 12/07/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit

class EsportVC: UITableViewController {

    var articles = [Article]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = "Esport"
        // Add Big Titles
        self.navigationController?.navigationBar.prefersLargeTitles = true
        getEsportArticles(completion: {
            res in
            
            self.articles = res
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Let's start with articles
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return articles.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        let article = articles[indexPath.row]
        
        cell.title.text = article.title
        cell.desc.text = article.description
        cell.date.text = article.date

        //let cellHeight = cell.title.bounds.height + cell.desc.bounds.height + cell.date.bounds.height + 8*4
        
        return cell
    }
}
