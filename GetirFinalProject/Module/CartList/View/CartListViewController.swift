//
//  CartListViewController.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 21.04.2024.
//

import UIKit

protocol CartListViewControllerProtocol: AnyObject {
    func prepareViewDidLoad()
    func deletedAllProducts()
    func deleteRow(at indexPath: IndexPath)
    func reloadCollectionView()
    func reloadTableView()
}

final class CartListViewController: UIViewController {
    
    var presenter: CartListPresenterProtocol?
    private var collectionView: UICollectionView? = nil
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let cartListContainerView: CartListContainerView = {
        let view = CartListContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
}

extension CartListViewController: CartListViewControllerProtocol {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func prepareViewDidLoad() {
        configureSuperview()
        configureSubviews()
        configureTableView()
        configureCollectionView()
        configureConstraints()
        configureNavigationBar()
        setDelegates()
    }
    
    func deletedAllProducts() {
        reloadData()
    }
    
    func deleteRow(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
}

extension CartListViewController {
    private func configureSubviews() {
        view.addSubview(tableView)
        view.addSubview(cartListContainerView)
    }
    
    private func configureSuperview() {
        view.backgroundColor = UIColor.named(Constants.Colors.sectionHeaderColor)
    }
    
    private func configureNavigationBar() {
        title = Constants.NavigationItem.cartListTitle
        
        let leftBarButtonImageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .default)
        let leftBarButtonImage = UIImage.systemName(Constants.ImageName.xmark).withConfiguration(leftBarButtonImageConfig)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftBarButtonImage, style: .plain, target: self, action: #selector(backButtonPressed))
        
        let rightBarButtonImageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold, scale: .default)
        let rightBarButtonImage = UIImage.named(Constants.ImageName.trashButtonIcon).withConfiguration(rightBarButtonImageConfig)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarButtonImage, style: .plain, target: self, action: #selector(deleteButtonPressed))
    }
    
    private func configureTableView() {
        tableView.register(CartListCell.self)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        guard let collectionView = collectionView else { return }
        collectionView.isScrollEnabled = false
        collectionView.register(ProductListCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: Identifier.sectionHeaderIdentifier.rawValue,
                                withReuseIdentifier: HeaderView.reuseIdentifier)
        view.addSubview(collectionView)
    }
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        cartListContainerView.delegate = self
    }
    
    private func configureConstraints() {
        guard let collectionView = collectionView else { return }
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            cartListContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cartListContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartListContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartListContainerView.heightAnchor.constraint(equalToConstant: 100),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
}

extension CartListViewController {
    @objc private func backButtonPressed() {
        presenter?.navigateToBack()
    }
}

extension CartListViewController {
    @objc private func deleteButtonPressed() {
        showDeletedProductAlert(title: "Sepeti Boşalt", message: "Sepetini boşaltmak istediğinden emin misin?") { actionType in
            if actionType == .ok {
                self.presenter?.deleteButtonPressed()
            }
        }
    }
}

extension CartListViewController {
    private func reloadData() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.tableView.reloadData()
            }
        }
    }
}

extension CartListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else {
            fatalError("CartListViewController: Could not create presenter")
        }
        return presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter = presenter else {
            return .init()
        }
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CartListCell
        let productPresentation = presenter.getProductPresentation(at: indexPath)
        CartListCellBuilder.createCell(cell, presentation: productPresentation, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter = presenter else {
            return .init()
        }
        return presenter.heightForRow()
    }
}

extension CartListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.navigateToProductDetail(at: indexPath)
    }
}

extension CartListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as! HeaderView
        header.configure(with: "Önerilen Ürünler")
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let presenter = presenter else {
            fatalError("ProductListViewController: Error happened in numberOfItemsInSection")
        }
        return presenter.numberOfRowsInSectionRecommendedProducts()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let presenter = presenter else {
            return .init()
        }
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ProductListCell
        let productPresentation = presenter.getRecommendedProductPresentation(at: indexPath)
        ProductListCellBuilder.createCell(cell, presentation: productPresentation)
        return cell
    }
}

extension CartListViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let horizontalListLayout = self.makeHorizontalListLayout()
            return horizontalListLayout
        }
    }
}

extension CartListViewController {
    private func makeHorizontalListLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.2/4), heightDimension: .fractionalWidth(1.5/3)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: Identifier.sectionHeaderIdentifier.rawValue, alignment: .top)
        
        section.interGroupSpacing = 0
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 3)
        section.boundarySupplementaryItems = [header]
        return section
    }
}

extension CartListViewController: CartListContainverViewProtocol {
    func makeOrderButtonPressed(totalCost: String) {
        showAlert(title: "Sipariş Başarılı", message: "Siparişiniz alındı. Toplam Ücret = \(totalCost)", completion: { [weak self] in
            guard let self = self else { return }
            self.presenter?.orderCompleted()
        })
    }
}
