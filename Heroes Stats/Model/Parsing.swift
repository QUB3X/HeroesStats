//
//  Parsing.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 25/06/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import Foundation

func parseRank(_ string: String?) -> String {
    if string == nil {
        return "?"
    }
    let newString = string!.split(separator: ":")[1].replacingOccurrences(of: "[ ()]", with: "", options: [.regularExpression])
    
    return newString
}

func parseTimePlayed(_ string: String?) -> String {
    if string == nil {
        return "?"
    }
    let newString = string!.replacingOccurrences(of: " Days", with: "d").replacingOccurrences(of: " Hours", with: "h").replacingOccurrences(of: " Minutes", with: "m")
    
    return newString
}

func parseHeroName(_ name: String) -> String {
    return name.replacingOccurrences(of: "ú", with: "u").replacingOccurrences(of: " ", with: "-").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "'", with: "").lowercased()
}

func parsePlayerData(_ data: Data) throws -> Player {
    let _player = try JSONDecoder().decode(s_Player.self, from: data)
    
    return Player(player: _player)
}

func parseHeroData(_ data: Data) throws -> HeroDetails {
    let _hero = try JSONDecoder().decode(s_Hero_Detail.self, from: data)
    
    return HeroDetails(heroDetails: _hero)
}

func parseHeroesData(_ data: Data) throws -> [Hero] {
    let _heroes_cont = try JSONDecoder().decode(s_HeroesContainer.self, from: data)
    var heroes: [Hero] = []
    
    for _hero in _heroes_cont.heroes {
        heroes.append(Hero(hero: _hero))
    }
    return heroes
}

// For Welcome Page and Player Search
func parseId(_ data: Data) throws -> String {
    let obj = try JSONDecoder().decode(s_Id.self, from: data)
    let id = "\(obj.id)"
    return id
}

func validateInput(_ input: String) -> Bool {
    if input != "" {
        let battleTagRegex = "^[A-zÀ-ú][A-zÀ-ú0-9]{2,11}#[0-9]{4,5}$"
        let battleTagTest = NSPredicate(format: "SELF MATCHES[c] %@", battleTagRegex)
        return battleTagTest.evaluate(with: input)
    }
    return false
}
