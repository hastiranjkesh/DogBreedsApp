//
//  BreedImagesViewModel.swift
//  DogBreedsApp
//
//  Created by hasti ranjkesh on 10/20/22.
//

import Foundation
import Combine

protocol BreedImagesViewModelProtocol {
    // Define error and isLoadingFinished publisher
    // Because properties declared inside a protocol cannot have a wrapper
    var errorPublisher: Published<Error?>.Publisher { get }
    var loadingFinishedPublisher: Published<Bool>.Publisher { get }
    var breedName: String { get }
    
    func getBreedAllImages()
    func getBreedImagePath(at index: Int) -> String
    func getControllerTitle() -> String
    func numberOfItemsInSection() -> Int
}

final class BreedImagesViewModel: BreedImagesViewModelProtocol {
    @Published var error: Error?
    @Published var isLoadingFinished: Bool = false
    
    // Manually expose error and isLoadingFinished publisher
    var errorPublisher: Published<Error?>.Publisher { $error }
    var loadingFinishedPublisher: Published<Bool>.Publisher { $isLoadingFinished }
    
    private var cancellable = Set<AnyCancellable>()
    private var apiManager: ApiManagerProtocol
    var allImages: [String]?
    let breedName: String
    
    init(breedName: String, apiManager: ApiManagerProtocol) {
        self.breedName = breedName
        self.apiManager = apiManager
    }
    
    func getBreedAllImages() {
        let urlPath = "https://dog.ceo/api/breed/\(breedName)/images"
        guard let url = URL(string: urlPath) else { return }
        apiManager.getData(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {[weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error
                case .finished:
                    self?.isLoadingFinished = true
                }
            }, receiveValue: { [weak self] images in
                self?.allImages = images.message
            })
            .store(in: &cancellable)
    }
    
    func getBreedImagePath(at index: Int) -> String {
        allImages?[index] ?? ""
    }
    
    func getControllerTitle() -> String {
        breedName
    }
    
    func numberOfItemsInSection() -> Int {
        allImages?.count ?? 0
    }
}
