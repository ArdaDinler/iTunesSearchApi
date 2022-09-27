//
//  ListViewController.swift
//  iTunesSearchApi
//
//  Created by Arda Dinler on 27.09.2022.
//

import UIKit
import Combine

class ListViewController: UICollectionViewController {

    // MARK: - Properties
    private var bindings = Set<AnyCancellable>()
    private var searchController = UISearchController(searchResultsController: nil)
    var viewModel = ViewModel()

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        prepareViewComponents()
    }

    // MARK: - Private -
    private func prepareViewComponents() {
        configureSearchController()
        bindSearchBar()
        bindViewModel()
    }

    private func bindSearchBar() {
        NotificationCenter.default.publisher(for:
                                                    UISearchTextField.textDidChangeNotification,
                                                object: searchController.searchBar.searchTextField)
            .map {
                ($0.object as! UISearchTextField).text
            }.debounce(for: .seconds(0.7), scheduler: DispatchQueue.main).removeDuplicates()
            .sink { [weak self] (value) in
                guard let strongSelf = self,
                      let text = value else { return }
                strongSelf.viewModel.searchQuery = text
            }.store(in: &bindings)
    }

    private func bindViewModel() {
    }

    private func configureSearchController() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchQuery = ""
    }
}
