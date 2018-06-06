//
//  DataModels.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 28/05/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import Foundation

struct Player: Decodable {
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
    let heroes: [Hero]?
    let maps: [Map]?
}

struct Hero: Decodable {
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
struct Hero_Detail: Decodable {
    let lastUpdate: Int
    let talents: [[Talent]]
    let matchups: [Hero]
    let mapWinrate: [Map]
}
struct HeroesContainer: Decodable {
    let lastUpdate: Int
    let heroes: [Hero]
}
