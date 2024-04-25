//
//  CartListPresenter.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 21.04.2024.
//

import Foundation

protocol CartListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func navigateToBack()
    func navigateToProductDetail(at indexPath: IndexPath)
    func deleteButtonPressed()
    func numberOfRowsInSection() -> Int
    func numberOfRowsInSectionRecommendedProducts() -> Int
    func heightForRow() -> CGFloat
    func getProductPresentation(at indexPath: IndexPath) -> ProductPresentation
    func getRecommendedProductPresentation(at indexPath: IndexPath) -> ProductPresentation
    func orderCompleted()
}

final class CartListPresenter {
    weak private var view: CartListViewControllerProtocol?
    private let interactor: CartListInteractorProtocol?
    private let router: CartListRouterProtocol?
    private var presentations = Observable<[ProductPresentation]>([])
    private var recommendedProducts = Observable<[ProductPresentation]>([])
    
    init(view: CartListViewControllerProtocol?, interactor: CartListInteractorProtocol?, router: CartListRouterProtocol?) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension CartListPresenter: CartListPresenterProtocol {
    func navigateToProductDetail(at indexPath: IndexPath) {
        let presentation = recommendedProducts.value[indexPath.item]
        router?.navigate(.productDetail(presentation: presentation))
    }
    
    func getRecommendedProductPresentation(at indexPath: IndexPath) -> ProductPresentation {
        recommendedProducts.value[indexPath.row]
    }
    
    func numberOfRowsInSectionRecommendedProducts() -> Int {
        recommendedProducts.value.count
    }
    
    func heightForRow() -> CGFloat {
        Constants.CartList.heightForRow
    }
    
    func orderCompleted() {
        let productsIDs = presentations.value.compactMap { $0.id }
        interactor?.deleteProducts(productsIDs: productsIDs)
        router?.navigate(.popToRoot)
    }
    
    func deleteButtonPressed() {
        let productsIDs = presentations.value.compactMap { $0.id }
        interactor?.deleteProducts(productsIDs: productsIDs)
        router?.navigate(.popToRoot)
    }
    
    func getProductPresentation(at indexPath: IndexPath) -> ProductPresentation {
        presentations.value[indexPath.item]
    }
    
    func numberOfRowsInSection() -> Int {
        presentations.value.count
    }
    
    func navigateToBack() {
        router?.navigate(.back)
    }
    
    func viewDidLoad() {
        view?.prepareViewDidLoad()
        interactor?.fetchProductsInCart()
        interactor?.fetchRecommendedProducts()
        interactor?.observeProducts()
    }
}

extension CartListPresenter: CartListInteractorOutputProtocol {
    func observeProductsOutput(products: [ProductInCart]) {
        presentations.value = products.map { product in
            ProductPresentation(id: product.id, name: product.name, attribute: product.attribute, price: product.price, imageURL: product.imageURL, currentAmount: product.currentAmount)
        }
        view?.reloadTableView()
        view?.reloadCollectionView()
    }
    
    func fetchRecommendedProductsOutputs(_ result: Result<[HListProductsModel], any Error>) {
        switch result {
        case .success(let responseModel):
            makeRecommendedListProductPresentation(with: responseModel)
            view?.reloadCollectionView()
        
        case .failure(let error):
            print(error)
        }
    }
    
    func deletedProductsInCartOutput() {
        presentations.value.removeAll()
        view?.deletedAllProducts()
    }
    
    func fetchProductsInCartOutput(_ products: [ProductInCart]) {
        makeProductPresentation(products: products)
    }
}

extension CartListPresenter {
    private func makeProductPresentation(products: [ProductInCart]) {
        presentations.value = products.map { product in
            ProductPresentation(id: product.id, name: product.name, attribute: product.attribute, price: product.price, imageURL: product.imageURL, currentAmount: product.currentAmount)
        }
    }
}

extension CartListPresenter {
    private func makeRecommendedListProductPresentation(with responseModel: [HListProductsModel]) {
        guard let products = responseModel.first?.products else {
            return
        }
        
        recommendedProducts.value = products.map { product in
            ProductPresentation(id: product.id, name: product.name, attribute: " ", price: product.price, imageURL: product.imageURL ?? product.squareThumbnailURL, currentAmount: "0")
        }
    }
}
