//
//  Networking.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 28/05/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import Foundation
import Alamofire
import Kanna

let API_URL = "https://heroes-api.glitch.me/api/v1/"
let TALENTS_URL = "https://github.com/QUB3X/hots-talents-bundle/releases/download/warchrome-patch/talents.zip"
let PATCH_URL = "https://heroespatchnotes.com/patch/"

let ESPORT_ARTICLES_URL = "https://esports.heroesofthestorm.com/en-us/articles"

func getPlayer(playerId: String, completion: @escaping (Player) -> Void) {
    //print("fetching player data...")

    Alamofire.request(API_URL + "players/\(playerId)").response {
        res in
        if let json = res.data {
        
            do {
                let player = try parsePlayerData(json)
                // return the player object
                completion(player)
                //print("Fetch complete!")
            } catch {
                print(error)
            }
        } else {
            print("No Json")
        }
    }
}

func getHero(heroName: String, completion: @escaping (HeroDetails) -> Void) {
    //print("fetching hero data...")
    if let heroName = heroName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
        
        let url = API_URL + "heroes/\(heroName)"
        
        Alamofire.request(url).response {
            res in
            
            if let json = res.data {
            
                do {
                    let hero = try parseHeroData(json)
                    // return the hero object
                    completion(hero)
                    //print("Fetch complete!")
                } catch {
                    print(error)
                }
            } else {
                print("No Json")
            }
        }
    }
}
func getHeroes(completion: @escaping ([Hero]) -> Void) {
    //print("Fetching hero data...")
    
    Alamofire.request(API_URL + "heroes").response {
        res in
        
        if let json = res.data {
        
            do {
                // It's a container
                let heroes = try parseHeroesData(json)
                // return the heroes array object
                completion(heroes)
                //print("Fetch complete!")
            } catch {
                print(error)
            }
        } else {
            print("No Json")
        }
    }
}

func getPatches(completion: @escaping ([Patch]) -> Void) {
    
    Alamofire.request(PATCH_URL).response {
        res in
        
        if let html = res.data {
            
            if let doc = try? HTML(html: html, encoding: .utf8) {
                // Search for nodes by CSS
                
                var patches = [Patch]()
                
                for patch in doc.css(".timeline > li") {
                    let title = patch.css("h3").first?.text ?? ""
                    let version = String(title.split(separator: " ").last!) 
                    let url = patch.css("a").first!["href"] ?? ""
                    patches.append(Patch(_title: title,
                                         _version: version,
                                         _url: url))
                }
                completion(patches)
            }
        } else {
            print("No HTML")
        }
    }
}

func getPatch(url: String, completion: @escaping (String, String) -> Void) {
    
    Alamofire.request(PATCH_URL + url).response {
        res in
        
        if let html = res.data {
            
            if let doc = try? HTML(html: html, encoding: .utf8) {
                // Search for nodes by CSS
                
                let body = doc.css("#top > div").first
                let title = String((body?.css("h1").first?.text?.split(separator: "–").last)!)
                let content = body?.toHTML
                completion(title, content!)
            }
        } else {
            print("No HTML")
        }
    }
}

func getPlayerIdFrom(battleTag: String, region: String, completion: @escaping (String, Bool) -> () ) {
    Alamofire.request("\(API_URL)players/battletag/\(region)/\(battleTag)").response { response in
        if let data = response.data, let text = String(data: data, encoding: .utf8) {
            print(text)
           
            do {
                let playerId = try parseId(data)
                
                completion(playerId, false)
                
            } catch {
                // error
                print(error)
                completion(String(describing: error), true)
            }
        }
    }
}

func getEsportArticles(completion: @escaping ([Article]) -> Void) {
    
    Alamofire.request(ESPORT_ARTICLES_URL).response {
        res in
        
        if let html = res.data {
            if let doc = try? HTML(html: html, encoding: .utf8) {
                // Search for nodes by CSS
                
                var articles = [Article]()
                
                // articles
                for item in doc.css(".NewsArchive-articleList a") {
                    let title = item.css(".News-articleTitle").first?.text ?? ""
                    let date = item.css(".News-articleNote").first?.text ?? ""
                    let description = item.css(".News-articleNote").first?.text ?? ""
                    let url = item["href"] ?? ""
                    
                    articles.append(Article(_title: title, _date: date, _url: url, _desc: description))
                }
                
                completion(articles)
            }
        } else {
            print("No HTML")
        }
    }
}

func getEsportArticle(url: String, completion: @escaping (String) -> Void) {
    
    Alamofire.request("https://esports.heroesofthestorm.com" + url).response {
        res in
        
        if let html = res.data {
            
            if let doc = try? HTML(html: html, encoding: .utf8) {
                // Search for nodes by CSS
                
                let body = doc.css(".NewsArticle-wrapper").first
                let content = body?.toHTML
                completion(content!)
            }
        } else {
            print("No HTML")
        }
    }
}
