//
//  DataModels.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 28/05/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import Foundation

/**
 *      s_
 *      is for STRUCTS that
 *      they should not be used in code
 */

struct s_Player: Decodable {
    let playerName: String
    let teamLeague: String?
    let heroLeague: String?
    let unrankedDraft: String?
    let quickMatch: String?
    let MVPrate: Float?
    let winrate: Float?
    let heroLevel: Int?
    let gamesPlayed: Int?
    let timePlayed: String?
    let heroes: [s_Hero]?
    let maps: [Map]?
}

struct s_Hero: Decodable {
    let name: String
    let gamesPlayed: Int?
    let averageGameLength: String?
    let winrate: Float?
    let gamesBanned: Int?
    let deltaWinrate: Float?
    let popularity: Float?
}
struct Map: Decodable {
    let name: String
    let gamesPlayed: Int?
    let averageGameLength: String?
    let winrate: Float?
}

struct Talent: Decodable {
    let name: String
    let description: String?
    let gamesPlayed: Int?
    let popularity: Float?
    let winrate: Float?
}
struct s_Hero_Detail: Decodable {
    let lastUpdate: Int
    let talents: [[Talent]]
    let matchups: [s_Hero]
    let mapWinrate: [Map]
}
struct s_HeroesContainer: Decodable {
    let lastUpdate: Int
    let heroes: [s_Hero]
}

class Player: NSObject {
    init(player: s_Player) {
        playerName = player.playerName
        teamLeague = parseRank(player.teamLeague)
        heroLeague = parseRank(player.heroLeague)
        unrankedDraft = parseRank(player.unrankedDraft)
        quickMatch = parseRank(player.quickMatch)
        MVPrate = player.MVPrate ?? 0.0
        winrate = player.winrate ?? 0.0
        heroLevel = player.heroLevel ?? 0
        gamesPlayed = player.gamesPlayed ?? 0
        timePlayed = parseTimePlayed(player.timePlayed)
        heroes = player.heroes ?? []
        maps = player.maps ?? []
    }
    
    let playerName: String
    let teamLeague: String
    let heroLeague: String
    let unrankedDraft: String
    let quickMatch: String
    let MVPrate: Float
    let winrate: Float
    let heroLevel: Int
    let gamesPlayed: Int
    let timePlayed: String
    let heroes: [s_Hero]
    let maps: [Map]
}

class Hero: NSObject {
    init(hero: s_Hero) {
        name = hero.name
        gamesPlayed = hero.gamesPlayed ?? 0
        gamesBanned = hero.gamesBanned ?? 0
        averageGameLength = hero.averageGameLength ?? "--:--:--" // i guess
        winrate = hero.winrate ?? 0.0
        deltaWinrate = hero.deltaWinrate ?? 0.0
        popularity = hero.popularity ?? 0.0
    }
    let name: String
    let gamesPlayed: Int
    let gamesBanned: Int
    let averageGameLength: String
    let winrate: Float
    let deltaWinrate: Float
    let popularity: Float
    
    
}

class HeroDetails: NSObject {
    init(heroDetails: s_Hero_Detail) {
        talents = heroDetails.talents
        var heroes: [Hero] = []
        
        for hero in heroDetails.matchups {
            heroes.append(Hero(hero: hero))
        }
        matchups = heroes
        mapWinrate = heroDetails.mapWinrate
    }
    let talents: [[Talent]]
    let matchups: [Hero]
    let mapWinrate: [Map]
}

// funcs
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
