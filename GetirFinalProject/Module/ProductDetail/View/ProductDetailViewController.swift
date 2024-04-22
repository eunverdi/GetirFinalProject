//
//  ProductDetailViewController.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 14.04.2024.
//

import UIKit

protocol ProductDetailViewControllerProtocol: AnyObject {
    func configureSubviews()
    func configureSuperview()
    func configureNavigationBar()
    func configureProductStatus(productCount: String)
    func setDelegates()
}

final class ProductDetailViewController: UIViewController {
    
    var presenter: ProductDetailPresenterProtocol?
    
    private let productDetailsView: ProductDetailsView = {
        let view = ProductDetailsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cartStatusContainerView: CartStatusContainerView = {
        let view = CartStatusContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cartButton = CartButtonView()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.setTitle("Sepete Ekle", for: .normal)
        button.backgroundColor = UIColor.named(Constants.Colors.appMainColor)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: Constants.Fonts.openSansBold, size: 14)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad(detailsView: productDetailsView)
        NotificationCenter.default.addObserver(self, selector: #selector(checkTotalCost(_:)), name: NSNotification.Name("TotalCostUpdated"), object: nil)
    }
    
    @objc func checkTotalCost(_ notification: Notification) {
        if let totalCost = notification.userInfo?["totalCost"] as? Double {
            navigationItem.rightBarButtonItem?.isHidden = false
        }
    }
}

extension ProductDetailViewController: ProductDetailViewControllerProtocol {
    func setDelegates() {
        cartStatusContainerView.delegate = self
        cartButton.delegate = self
    }
    
    func configureProductStatus(productCount: String) {
        cartStatusContainerView.configureComponents(productCount: productCount)
    }
    
    func configureSuperview() {
        view.backgroundColor = .systemBackground
    }
    
    func configureSubviews() {
        view.addSubview(cartStatusContainerView)
        view.addSubview(productDetailsView)
        setupConstraints()
    }
    
    func configureNavigationBar() {
        navigationItem.title = Constants.NavigationItem.productDetailTitle
        let font = UIFont(name: Constants.Fonts.openSansBold, size: 14)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
        let backButtonImageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .default)
        let backButtonImage = UIImage.systemName("xmark").withConfiguration(backButtonImageConfig)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        navigationItem.rightBarButtonItem?.isHidden = true
    }
}

extension ProductDetailViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productDetailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productDetailsView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33),
            
            cartStatusContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cartStatusContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartStatusContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartStatusContainerView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc func backButtonPressed() {
        presenter?.backButtonPressed()
    }
}

extension ProductDetailViewController: CartStatusProtocol {
    func updateProductCount(with count: String) {
        presenter?.updateProductCount(with: count)
    }
    
    func addProductToCart() {
        presenter?.addProductToCart()
    }
    
    func deleteProductFromCart() {
        presenter?.deleteProductFromCart()
    }
}

extension ProductDetailViewController: CartButtonViewProtocol {
    func cartButtonPressed() {
        presenter?.navigateToCart()
    }
}
