//
//  BreedImagesViewController.swift
//  DogBreedsApp
//
//  Created by hasti ranjkesh on 10/20/22.
//

import UIKit
import Combine

final class BreedImagesViewController: UIViewController {
    
    private let viewModel: BreedImagesViewModelProtocol
    private var cancellable = Set<AnyCancellable>()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(BreedImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: BreedImageCollectionViewCell.cellIdentifier)
        return collectionView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    init(viewModel: BreedImagesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel.getBreedAllImages()
        addObservers()
    }
    
    private func setupUI() {
        addSubviews()
        addConstraints()
        navigationItem.title = viewModel.getControllerTitle()
        activityIndicator.startAnimating()
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func addObservers() {
        viewModel.loadingFinishedPublisher
            .receive(on: DispatchQueue.main)
            .sink {[weak self] isLoadingFinished in
                self?.activityIndicator.stopAnimating()
                if isLoadingFinished {
                    self?.collectionView.reloadData()
                }
            }
            .store(in: &cancellable)
        
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { error in
                if let error = error {
                    print("Something went wrong! \(error.localizedDescription)")
                    // TODO: could show an alert view here
                }
            }
            .store(in: &cancellable)
    }
}

// MARK: - UICollectionViewDataSource

extension BreedImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreedImageCollectionViewCell.cellIdentifier,
                                                      for: indexPath) as! BreedImageCollectionViewCell
        cell.setContent(imagePath: viewModel.getBreedImagePath(at: indexPath.row))
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BreedImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (view.frame.width-32)/2, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}
