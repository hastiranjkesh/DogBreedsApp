//
//  FavoriteEntity.swift
//  DogBreedsApp
//
//  Created by hasti ranjkesh on 10/20/22.
//

import RealmSwift
import Foundation

final class FavoriteEntity: Object {
    @Persisted var name: String
    @Persisted var image: String
    
    @Persisted  var id: PrimaryKeyType = UUID().uuidString
    typealias PrimaryKeyType = String
    override static func primaryKey() -> String? { return "id" }
}
