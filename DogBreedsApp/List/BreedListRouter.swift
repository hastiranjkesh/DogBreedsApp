//
//  BreedListRouter.swift
//  DogBreedsApp
//
//  Created by hasti ranjkesh on 10/20/22.
//

import UIKit

protocol BreedListRouterProtocol {
    func goToBreedDetails(_ breedName: String)
}

final class BreedListRouter: BreedListRouterProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func goToBreedDetails(_ breedName: String) {
        let viewModel = BreedImagesViewModel(breedName: breedName, apiManager: ApiManager())
        let breedImagesViewController = BreedImagesViewController(viewModel: viewModel)
        viewController?.navigationController?.pushViewController(breedImagesViewController, animated: true)
    }
}
