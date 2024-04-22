//
//  CartListPresenter.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 21.04.2024.
//

import Foundation

protocol CartListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func backButtonPressed()
    func deleteButtonPressed()
    func numberOfRowsInSection() -> Int
    func getProductPresentation(at indexPath: IndexPath) -> ProductPresentation
    func orderCompleted()
}

final class CartListPresenter {
    weak private var view: CartListViewControllerProtocol?
    private let interactor: CartListInteractorProtocol?
    private let router: CartListRouterProtocol?
    
    private var presentation: [ProductPresentation] = []
    
    init(view: CartListViewControllerProtocol?,
         interactor: CartListInteractorProtocol?,
         router: CartListRouterProtocol?) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension CartListPresenter: CartListPresenterProtocol {
    func orderCompleted() {
        let productsIDs = presentation.compactMap({ $0.id })
        interactor?.deleteProducts(productsIDs: productsIDs)
        router?.navigate(.productList)
    }
    
    func deleteButtonPressed() {
        let productsIDs = presentation.compactMap({ $0.id })
        interactor?.deleteProducts(productsIDs: productsIDs)
    }
    
    func getProductPresentation(at indexPath: IndexPath) -> ProductPresentation {
        presentation[indexPath.item]
    }
    
    func numberOfRowsInSection() -> Int {
        presentation.count
    }
    
    func backButtonPressed() {
        router?.navigate(.back)
    }
    
    func viewDidLoad() {
        view?.prepareViewDidLoad()
        interactor?.fetchProducts()
    }
}

extension CartListPresenter: CartListInteractorOutputProtocol {
    func deletedProductsInCartOutput() {
        view?.reloadData()
    }
    
    func fetchProductsInCartOutput(_ products: [ProductInCart]) {
        makeProductPresentation(products: products)
        view?.reloadData()
    }
}

extension CartListPresenter {
    private func makeProductPresentation(products: [ProductInCart]) {
        presentation = products.map { product in
            return ProductPresentation(id: product.id,
                                       name: product.name,
                                       attribute: product.attribute,
                                       price: product.price,
                                       imageURL: product.imageURL,
                                       currentAmount: product.currentAmount)
        }
    }
}
