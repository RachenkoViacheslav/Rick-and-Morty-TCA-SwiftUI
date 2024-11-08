//
//  RealmPageInfo.swift
//  Rick_Morty_Test
//
//  Created by MIF Projects on 08.11.2024.
//

import Foundation
import RealmSwift

class RealmPageInfo: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var count: Int
    @Persisted var pages: Int
    @Persisted var next: String?
    @Persisted var prev: String?
    
    convenience init(from pageInfo: PageInfo) {
        self.init()
        
        self.count = pageInfo.count
        self.pages = pageInfo.pages
        self.next = pageInfo.next?.absoluteString
        self.prev = pageInfo.prev?.absoluteString
    }
}
