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
}

final class CartListViewController: UIViewController {
    
    var presenter: CartListPresenterProtocol?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
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
    func prepareViewDidLoad() {
        configureSuperview()
        configureSubviews()
        setupTableView()
        configureConstraints()
        configureNavigationBar()
        setDelegates()
    }
    
    func deletedAllProducts() {
        reloadData()
    }
}

extension CartListViewController {
    private func configureSubviews() {
        view.addSubview(tableView)
        view.addSubview(cartListContainerView)
    }
    
    private func configureSuperview() {
        view.backgroundColor = .systemBackground
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
    
    private func setupTableView() {
        tableView.register(CartListCell.self)
    }
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        cartListContainerView.delegate = self
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            cartListContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cartListContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartListContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartListContainerView.heightAnchor.constraint(equalToConstant: 100)
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
        CartListCellBuilder.createCell(cell, presentation: productPresentation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CartListViewController: CartListContainverViewProtocol {
    func makeOrderButtonPressed(totalCost: String) {
        showAlert(title: "Sipariş Başarılı", message: "Siparişiniz alındı.Toplam Ücret \(totalCost)", completion: { [weak self] in
            guard let self = self else { return }
            self.presenter?.orderCompleted()
        })
    }
}
