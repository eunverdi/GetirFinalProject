//
//  ProductListViewController.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 8.04.2024.
//

import UIKit

fileprivate enum Identifier: String {
    case sectionHeaderIdentifier = "HeaderView"
}

enum Section: Int, CaseIterable {
    case horizontalListProducts
    case verticalListProducts
}

protocol ProductListViewControllerProtocol: AnyObject {
    func reloadData()
    func prepareViewDidLoad()
}

final class ProductListViewController: UIViewController {
    var presenter: ProductListPresenterProtocol?
    private var collectionView: UICollectionView? = nil
    private let cartButton = CartButtonView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
}

extension ProductListViewController: ProductListViewControllerProtocol {
    func prepareViewDidLoad() {
        setDelegates()
        configureSuperview()
        configureNavigationBar()
        configureCollectionView()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
}

extension ProductListViewController {
    private func setDelegates() {
        cartButton.delegate = self
    }
    
    private func configureSuperview() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationBar() {
        navigationItem.title = Constants.NavigationItem.productListTitle
        let font = UIFont(name: Constants.Fonts.openSansBold, size: 14)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        guard let collectionView = collectionView else { return }
        
        collectionView.register(ProductListCell.self, forCellWithReuseIdentifier: ProductListCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: Identifier.sectionHeaderIdentifier.rawValue, withReuseIdentifier: Identifier.sectionHeaderIdentifier.rawValue)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("")
        }
        presenter?.navigateToProductDetail(at: indexPath, section: section)
    }
}

extension ProductListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Identifier.sectionHeaderIdentifier.rawValue, for: indexPath)
        header.backgroundColor = Constants.Colors.sectionHeaderColor
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section), let presenter = presenter else {
            fatalError("")
        }
        switch section {
        case .horizontalListProducts:
            return presenter.numberOfRowsInSectionHorizontalListProducts()
        case .verticalListProducts:
            return presenter.numberOfRowsInSectionVerticalListProducts()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("")
        }
        
        guard let presenter = presenter else {
            return .init()
        }
        
        switch section {
        case .horizontalListProducts:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCell.identifier, for: indexPath) as? ProductListCell else { return UICollectionViewCell() }
            let productPresentation = presenter.getHListProductPresentation(at: indexPath)
            let cellInteractor = ProductListCellInteractor()
            ProductListCellBuilder.createCell(cell, presentation: productPresentation, interactor: cellInteractor)
            return cell
            
        case .verticalListProducts:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCell.identifier, for: indexPath) as? ProductListCell else { return UICollectionViewCell() }
            let productPresentation = presenter.getVListProductPresentation(at: indexPath)
            let cellInteractor = ProductListCellInteractor()
            ProductListCellBuilder.createCell(cell, presentation: productPresentation, interactor: cellInteractor)
            return cell
        }
    }
}

extension ProductListViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .horizontalListProducts:
                let horizontalListLayout = self.makeHorizontalListLayout()
                return horizontalListLayout
            case .verticalListProducts:
                let verticalListLayout = self.makeVerticalListLayout()
                return verticalListLayout
            }
        }
    }
}

extension ProductListViewController {
    private func makeVerticalListLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupHeight = NSCollectionLayoutDimension.fractionalWidth(1.05/2)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 10, trailing: 3)
        
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(16)),
                  elementKind: Identifier.sectionHeaderIdentifier.rawValue, alignment: .top)
        ]
        return section
    }
}

extension ProductListViewController {
    private func makeHorizontalListLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.2/4), heightDimension: .fractionalWidth(1.5/3)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 0
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 3)
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(16)),
                  elementKind: Identifier.sectionHeaderIdentifier.rawValue, alignment: .top),
        ]
        return section
    }
}

extension ProductListViewController: CartButtonViewProtocol {
    func cartButtonPressed() {
        presenter?.navigateToCart()
    }
}
