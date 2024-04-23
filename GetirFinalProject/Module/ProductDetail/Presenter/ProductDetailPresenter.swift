//
//  ProductDetailPresenter.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 14.04.2024.
//

import Foundation

protocol ProductDetailPresenterProtocol: AnyObject {
    func viewDidLoad(detailsView: ProductDetailsView)
    func backButtonPressed()
    func navigateToCart()
    func updateProductCount(with count: String)
    func addProductToCart()
    func deleteProductFromCart()
}

final class ProductDetailPresenter {
    weak private var view: ProductDetailViewControllerProtocol?
    private let interactor: ProductDetailInteractorProtocol?
    private let router: ProductDetailRouterProtocol?
    
    private var presentation: ProductPresentation?
    
    init(view: ProductDetailViewControllerProtocol?,
         interactor: ProductDetailInteractorProtocol?,
         router: ProductDetailRouterProtocol?,
         presentation: ProductPresentation?) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.presentation = presentation
    }
}

extension ProductDetailPresenter: ProductDetailPresenterProtocol {
    func navigateToCart() {
        router?.navigate(.cart)
    }
    
    func updateProductCount(with count: String) {
        guard var presentation = presentation else { return }
        presentation.currentAmount = count
        interactor?.updateProductCount(product: presentation)
    }
    
    func addProductToCart() {
        guard var presentation = presentation,
              let currentAmount = presentation.currentAmount,
              var amountIntValue = Int(currentAmount) else { return }
        amountIntValue += 1
        presentation.currentAmount = "\(amountIntValue)"
        interactor?.addProductToCart(presentation: presentation)
    }
    
    func deleteProductFromCart() {
        guard let presentation = presentation,
              let productID = presentation.id else { return }
        interactor?.deleteProductFromCart(productID: productID)
    }
    
    func viewDidLoad(detailsView: ProductDetailsView) {
        guard let presentation = presentation,
              let productID = presentation.id else {
            return
        }
        ProductDetailsViewBuilder.createView(detailsView, presentation: presentation)
        view?.configureSubviews()
        view?.configureNavigationBar()
        view?.configureSuperview()
        view?.setDelegates()
        interactor?.checkIsAddedToCart(productID: productID)
    }
    
    func backButtonPressed() {
        router?.navigate(.productList)
    }
}

extension ProductDetailPresenter: ProductDetailInteractorOutputProtocol {
    func productCountOutput(productCount: String) {
        view?.configureProductStatus(productCount: productCount)
    }
}
