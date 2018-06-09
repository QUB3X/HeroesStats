//
//  Networking.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 28/05/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import Foundation
import Alamofire

let API_URL = "https://heroes-api.glitch.me/api/v1/"

func getPlayer(playerId: String, completion: @escaping (Player) -> Void) {
    //print("fetching player data...")

    Alamofire.request(API_URL + "players/\(playerId)").response {
        res in
        if let json = res.data {
        
            do {
                let player = try parsePlayerData(data: json)
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
    
    Alamofire.request(API_URL + "heroes/\(heroName)").response {
        res in
        if let json = res.data {
        
            do {
                let hero = try parseHeroData(data: json)
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
func getHeroes(completion: @escaping ([Hero]) -> Void) {
    //print("Fetching hero data...")
    
    Alamofire.request(API_URL + "heroes").response {
        res in
        
        if let json = res.data {
        
            do {
                // It's a container
                let heroes = try parseHeroesData(data: json)
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

func parseHeroName(name: String) -> String {
    return name.replacingOccurrences(of: "[ -.ú]", with: "", options: [.regularExpression]).replacingOccurrences(of: " ", with: "-").lowercased()
}

private func parsePlayerData(data: Data) throws -> Player {
        let _player = try JSONDecoder().decode(s_Player.self, from: data)
    
        return Player(player: _player)
}
private func parseHeroData(data: Data) throws -> HeroDetails {
    let _hero = try JSONDecoder().decode(s_Hero_Detail.self, from: data)
    
    return HeroDetails(heroDetails: _hero)
}
private func parseHeroesData(data: Data) throws -> [Hero] {
    let _heroes_cont = try JSONDecoder().decode(s_HeroesContainer.self, from: data)
    var heroes: [Hero] = []
    
    for _hero in _heroes_cont.heroes {
        heroes.append(Hero(hero: _hero))
    }
    return heroes
}
