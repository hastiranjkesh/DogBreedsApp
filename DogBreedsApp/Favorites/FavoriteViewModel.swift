//
//  FavoriteViewModel.swift
//  DogBreedsApp
//
//  Created by hasti ranjkesh on 10/20/22.
//

import Foundation

struct FavModel {
    let breedName: String
    let image: String
}

protocol FavoriteViewModelProtocol {
    func fetchAllFavorites()
}

final class FavoriteViewModel: FavoriteViewModelProtocol {
    private var dataProvider: RealmDataProviderProtocol
    var allFavorites: [FavModel]?
    
    init(dataProvider: RealmDataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    func fetchAllFavorites() {
        let result = dataProvider.objects(FavoriteEntity.self, predicate: nil)
        guard let elements = result?.elements else { return }
        for item in elements {
            let fav = FavModel(breedName: item.name, image: item.image)
            allFavorites?.append(fav)
        }
    }
}
