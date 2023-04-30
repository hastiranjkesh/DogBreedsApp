//
//  BreedListViewModel.swift
//  DogBreedsApp
//
//  Created by hasti ranjkesh on 10/20/22.
//

import Foundation
import Combine

protocol BreedListViewModelProtocol {
    
    // Define error and isLoadingFinished publisher
    // Because properties declared inside a protocol cannot have a wrapper
    var errorPublisher: Published<Error?>.Publisher { get }
    var loadingFinishedPublisher: Published<Bool>.Publisher { get }
    
    func getBreedList()
    func numberOfRowsInSection() -> Int
    func getBreedName(at index: Int) -> String
    func getControllerTitle() -> String
}

final class BreedListViewModel: BreedListViewModelProtocol {
    @Published var error: Error?
    @Published var isLoadingFinished: Bool = false
    
    // Manually expose error and isLoadingFinished publisher
    var errorPublisher: Published<Error?>.Publisher { $error }
    var loadingFinishedPublisher: Published<Bool>.Publisher { $isLoadingFinished }
    
    private var cancellable = Set<AnyCancellable>()
    private var apiManager: ApiManagerProtocol
    var breeds: [String]?
    private let breedListURLString = "https://dog.ceo/api/breeds/list"
    
    init(apiManager: ApiManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func getBreedList() {
        guard let url = URL(string: breedListURLString) else { return }
        apiManager.getData(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error
                case .finished:
                    self?.isLoadingFinished = true
                }
            }, receiveValue: { [weak self] result in
                self?.breeds = result.message
            })
            .store(in: &cancellable)
    }
    
    func numberOfRowsInSection() -> Int {
        breeds?.count ?? 0
    }
    
    func getBreedName(at index: Int) -> String {
        breeds?[index] ?? ""
    }
    
    func getControllerTitle() -> String {
        "ALL BREEDS"
    }
}
