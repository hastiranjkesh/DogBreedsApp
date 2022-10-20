//
//  BreedImagesRouter.swift
//  DogBreedsApp
//
//  Created by hasti ranjkesh on 10/20/22.
//

import UIKit

protocol BreedImagesRouterProtocol {
    func goToFavorites(_ breedName: String, image: String)
}

final class BreedImagesRouter: BreedImagesRouterProtocol {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func goToFavorites(_ breedName: String, image: String) {
        
    }
}
