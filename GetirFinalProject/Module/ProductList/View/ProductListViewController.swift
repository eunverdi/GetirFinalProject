//
//  ProductListViewController.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 8.04.2024.
//

import UIKit

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
    private var collectionView: UICollectionView?
    private let cartButton = CartButtonView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
}

extension ProductListViewController: ProductListViewControllerProtocol {
    func prepareViewDidLoad() {
        setDelegates()
        configureSuperview()
        configureNavigationBar()
        configureCollectionView()
        setConstraints()
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        if let font = UIFont(name: Constants.Fonts.openSansBold, size: 14) {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
        }
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        guard let collectionView = collectionView else {
            return
        }
        
        collectionView.register(ProductListCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: Constants.Identifier.sectionHeaderIdentifier, withReuseIdentifier: Constants.Identifier.sectionHeaderIdentifier)
        view.addSubview(collectionView)
    }
    
    private func setConstraints() {
        guard let collectionView = collectionView else {
            return
        }
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("ProductListViewController: Invalid section directory")
        }
        presenter?.navigateToProductDetail(at: indexPath, section: section)
    }
}

extension ProductListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.Identifier.sectionHeaderIdentifier, for: indexPath)
        header.backgroundColor = UIColor.named(Constants.Colors.sectionHeaderColor)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section), let presenter = presenter else {
            fatalError("ProductListViewController: Error happened in numberOfItemsInSection")
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
            fatalError("ProductListViewController: Invalid section directory")
        }
        
        guard let presenter = presenter else {
            return .init()
        }
        
        switch section {
        case .horizontalListProducts:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ProductListCell
            let productPresentation = presenter.getHListProductPresentation(at: indexPath)
            ProductListCellBuilder.createCell(cell, presentation: productPresentation)
            return cell
            
        case .verticalListProducts:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ProductListCell
            let productPresentation = presenter.getVListProductPresentation(at: indexPath)
            ProductListCellBuilder.createCell(cell, presentation: productPresentation)
            return cell
        }
    }
}

extension ProductListViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
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
        
        let groupHeight = NSCollectionLayoutDimension.fractionalWidth(1.05 / 2)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 10, trailing: 3)
        
        section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(16)), elementKind: Constants.Identifier.sectionHeaderIdentifier, alignment: .top)]
        return section
    }
}

extension ProductListViewController {
    private func makeHorizontalListLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.2 / 4), heightDimension: .fractionalWidth(1.5 / 3)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 0
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 3)
        section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(16)), elementKind: Constants.Identifier.sectionHeaderIdentifier, alignment: .top)]
        return section
    }
}

extension ProductListViewController: CartButtonViewProtocol {
    func cartButtonPressed() {
        presenter?.navigateToCart()
    }
}
