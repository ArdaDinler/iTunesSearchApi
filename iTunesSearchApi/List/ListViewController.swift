//
//  ListViewController.swift
//  iTunesSearchApi
//
//  Created by Arda Dinler on 27.09.2022.
//

import UIKit
import Combine

class ListViewController: UICollectionViewController {
    // MARK: - Value Types
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Picture>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Picture>

    // MARK: - Properties
    private var bindings = Set<AnyCancellable>()
    private lazy var dataSource = makeDataSource()
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
        configureLayout()
        applySnapshot(animatingDifferences: false)
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
        viewModel.$sections.receive(on: DispatchQueue.main).sink { [weak self] (items) in
            guard let strongSelf = self,
                  items != nil else { return }
            strongSelf.applySnapshot(animatingDifferences: false)
        }.store(in: &bindings)
    }

    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, picture) ->
                UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "PictureCollectionViewCell",
                    for: indexPath) as? PictureCollectionViewCell
                cell?.picture = picture
                return cell
            })
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let section = self.dataSource.snapshot()
                .sectionIdentifiers[indexPath.section]
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier,
                for: indexPath) as? SectionHeaderReusableView
            view?.titleLabel.text = section.title
            return view
        }
        return dataSource
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(viewModel.sections ?? [])
        viewModel.sections?.forEach { section in
            snapshot.appendItems(section.pictures, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
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

// MARK: - Layout Handling
extension ListViewController {
    private func configureLayout() {
        collectionView.register(
            SectionHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier
        )
        collectionView.collectionViewLayout = createCompositionalLayout()
    }

    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            return self.createLayoutSection()
        }
    }

    private func createLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.50),heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 15, trailing: 15)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 15, trailing: 0)
        section.contentInsets.leading = 15
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension:.fractionalWidth(1), heightDimension: .estimated(44)), elementKind: UICollectionView.elementKindSectionHeader, alignment:.topLeading)]
        return section
    }
}
