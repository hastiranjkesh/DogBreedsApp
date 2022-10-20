//
//  BreedListRouter.swift
//  DogBreedsApp
//
//  Created by hasti ranjkesh on 10/20/22.
//

import UIKit

protocol BreedListRouterProtocol {
    func goToBreedDetails()
}

final class BreedListRouter: BreedListRouterProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func goToBreedDetails() {
        
    }
}
