//
//  RealmCharacter.swift
//  Rick_Morty_Test
//
//  Created by MIF Projects on 08.11.2024.
//

import Foundation
import RealmSwift

class RealmCharacter: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var status: String
    @Persisted var species: String
    @Persisted var type: String
    @Persisted var gender: String
    @Persisted var imageUrl: String
    @Persisted var location: Location?
    @Persisted var origin: Origin?
    
    convenience init(from character: Character) {
        self.init()
        self.id = character.id
        self.name = character.name
        self.status = character.status.rawValue
        self.species = character.species
        self.type = character.type
        self.gender = character.gender
        self.imageUrl = character.image.absoluteString
        self.location = Location(from: character.location)
        self.origin = Origin(from: character.origin)
    }
}

class Origin: Object {
    @Persisted var name: String
    @Persisted var url: String
    
    convenience init(from origin: Character.Origin) {
            self.init()
        self.name = origin.name
        self.url = origin.url
        }
}

class Location: Object {
    @Persisted var name: String
    @Persisted var url: String
    
    convenience init(from location: Character.Location) {
            self.init()
        self.name = location.name
        self.url = location.url
        }
}
