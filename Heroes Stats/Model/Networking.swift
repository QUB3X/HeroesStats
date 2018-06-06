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
        let json = res.data
        
        do {
            let player = try parsePlayerData(data: json!)
            // return the player object
            completion(player)
            //print("Fetch complete!")
        } catch {
            print(error)
        }
    }
}

func getHero(heroName: String, completion: @escaping (Hero_Detail) -> Void) {
    //print("fetching hero data...")
    
    Alamofire.request(API_URL + "heroes/\(heroName)").response {
        res in
        let json = res.data
        
        do {
            let hero = try parseHeroData(data: json!)
            // return the hero object
            completion(hero)
            //print("Fetch complete!")
        } catch {
            print(error)
        }
    }
}
func getHeroes(completion: @escaping ([Hero]) -> Void) {
    //print("Fetching hero data...")
    
    Alamofire.request(API_URL + "heroes").response {
        res in
        let json = res.data
        
        do {
            // It's a container
            let heroes = try parseHeroesData(data: json!)
            // return the heroes array object
            completion(heroes.heroes)
            //print("Fetch complete!")
        } catch {
            print(error)
        }
    }
}

func parseHeroName(name: String) -> String {
    return name.replacingOccurrences(of: "[ -.ú]", with: "", options: [.regularExpression]).replacingOccurrences(of: " ", with: "-").lowercased()
}

private func parsePlayerData(data: Data) throws -> Player {
        let player = try JSONDecoder().decode(Player.self, from: data)
        return player
}
private func parseHeroData(data: Data) throws -> Hero_Detail {
    let hero = try JSONDecoder().decode(Hero_Detail.self, from: data)
    return hero
}
private func parseHeroesData(data: Data) throws -> HeroesContainer {
    let heroes = try JSONDecoder().decode(HeroesContainer.self, from: data)
    return heroes
}
