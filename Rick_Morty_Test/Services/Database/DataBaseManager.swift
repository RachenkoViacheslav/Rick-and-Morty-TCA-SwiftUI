//
//  DataBaseManager.swift
//  Rick_Morty_Test
//
//  Created by MIF Projects on 06.11.2024.
//

import Foundation
import RealmSwift
import Dependencies
import ComposableArchitecture

@DependencyClient
struct DatabaseClient {
    var saveCharacters: @Sendable ([Character]) async throws -> Void
    var getAllCharacters: @Sendable () async -> [RealmCharacter] = { [] }
    var deleteAll: @Sendable () async throws -> Void
    
    var savePageInfo: @Sendable (PageInfo) async throws -> Void
    var loadPageInfo: @Sendable () async -> RealmPageInfo = { RealmPageInfo() }
    
}
extension DependencyValues {
    var dataBaseService: DatabaseClient {
        get { self[DatabaseClient.self] }
        set { self[DatabaseClient.self] = newValue }
    }
}

extension DatabaseClient: DependencyKey {
    static let liveValue = Self(
        saveCharacters: { characters in
            do {
                let realm = try Realm()
                let realmCharacters = characters.map { RealmCharacter(from: $0) }
                try realm.write {
                    realm.add(realmCharacters, update: .modified)
                }
            } catch {
                throw error
            }
        },
        
        getAllCharacters: {
            do {
                let realm = try Realm()
                let results = realm.objects(RealmCharacter.self)
                return Array(results)
            } catch {
                print("Error fetching characters from Realm: \(error)")
                return []
            }
        },
        
        deleteAll: {
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(realm.objects(RealmPageInfo.self))
                    realm.delete(realm.objects(RealmCharacter.self))
                }
            } catch {
                throw error
            }
        },
        
        savePageInfo: { page in
            do {
                let realm = try Realm()
                let pageData = RealmPageInfo(from: page)     
                try realm.write {
                    realm.delete(realm.objects(RealmPageInfo.self))
                    realm.add(pageData, update: .modified)
                }
            }
        }, 
        
        loadPageInfo: {
            do {
                let realm = try Realm()
                let result = realm.objects(RealmPageInfo.self).first
                return result ?? RealmPageInfo()
            } catch {
                print("Error fetching pagesInfo from Realm: \(error)")
                return RealmPageInfo()
            }
        }
    )
}
