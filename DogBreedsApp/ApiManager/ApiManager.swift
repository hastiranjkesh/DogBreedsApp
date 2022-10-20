//
//  ApiManager.swift
//  DogBreedsApp
//
//  Created by hasti ranjkesh on 10/20/22.
//

import Foundation
import Combine

protocol ApiManagerProtocol {
    func getBreedList(url: URL) -> AnyPublisher<Breed, Error>
}

final class ApiManager: ApiManagerProtocol {
    let session = URLSession.shared
    
    func getBreedList(url: URL) -> AnyPublisher<Breed, Error> {
        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .decode(type: Breed.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
