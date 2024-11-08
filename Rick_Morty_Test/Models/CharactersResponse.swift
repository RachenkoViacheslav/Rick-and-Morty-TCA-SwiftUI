//
//  Character.swift
//  Rick_Morty_Test
//
//  Created by MIF Projects on 05.11.2024.
//

import Foundation

struct CharactersResponse: Decodable, Equatable {
    let info: PageInfo
    let results: [Character]
}

struct PageInfo: Decodable, Equatable {
    let count: Int
    let pages: Int
    let next: URL?
    let prev: URL?
}
struct Character: Decodable, Equatable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: String
    let image: URL
    let location: Location
    let origin: Origin
    
    enum Status: String, Decodable, Equatable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "Unknown"
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let statusString = try container.decode(String.self).capitalized
            self = Status(rawValue: statusString) ?? .unknown
        }
    }
    
    struct Origin: Codable, Equatable {
        let name: String
        let url: String
    }
    
    struct Location: Codable, Equatable {
        let name: String
        let url: String
    }
}

extension Character {
    static let mock = Character(
        id: 89,
        name: "Dale",
        status: .dead,
        species: "Mythological Creature",
        type: "Giant",
        gender: "Male",
        image: URL(string: "https://rickandmortyapi.com/api/character/avatar/89.jpeg")!,
        location: Location(name: "Gaia", url: "https://rickandmortyapi.com/api/location/14"),
        origin: Origin(name: "Mount Olympus", url: "https://rickandmortyapi.com/api/location/90")
    )
}
