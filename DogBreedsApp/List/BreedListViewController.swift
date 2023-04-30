//
//  BreedListViewController.swift
//  DogBreedsApp
//
//  Created by hasti ranjkesh on 10/20/22.
//

import UIKit
import Combine

final class BreedListViewController: UIViewController {
    
    private let viewModel: BreedListViewModelProtocol
    var router: BreedListRouterProtocol?
    private var cancellable = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    init(viewModel: BreedListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.getBreedList()
        addObservers()
    }
    
    private func setupUI() {
        navigationItem.title = viewModel.getControllerTitle()
        addSubviews()
        addConstraints()
        activityIndicator.startAnimating()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
                if isLoadingFinished {
                    self?.activityIndicator.stopAnimating()
                    self?.tableView.reloadData()
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

// MARK: - UITableViewDataSource

extension BreedListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellIdentifier")
        }
        cell.textLabel?.text = viewModel.getBreedName(at: indexPath.row)
        return cell
    }
}


// MARK: - UITableViewDelegate

extension BreedListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.goToBreedDetails(viewModel.getBreedName(at: indexPath.row))
    }
}
