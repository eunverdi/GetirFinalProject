//
//  ProductListPresenter.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 8.04.2024.
//

import UIKit

protocol ProductListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func goToProductDetail(at indexPath: IndexPath, section: Section)
    func getVListProductPresentation(at indexPath: IndexPath) -> ProductPresentation
    func getHListProductPresentation(at indexPath: IndexPath) -> ProductPresentation
    func numberOfRowsInSectionHorizontalListProducts() -> Int
    func numberOfRowsInSectionVerticalListProducts() -> Int
}

final class ProductListPresenter {
    weak private var view: ProductListViewControllerProtocol?
    private let interactor: ProductListInteractorProtocol?
    private let router: ProductListRouterProtocol?
    
    private var horizontalListProducts: [ProductPresentation] = []
    private var verticalListProducts: [ProductPresentation] = []
    
    init(view: ProductListViewControllerProtocol?,
         interactor: ProductListInteractorProtocol?,
         router: ProductListRouterProtocol?) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}


extension ProductListPresenter: ProductListPresenterProtocol {
    func getVListProductPresentation(at indexPath: IndexPath) -> ProductPresentation {
        verticalListProducts[indexPath.item]
    }
    
    func getHListProductPresentation(at indexPath: IndexPath) -> ProductPresentation {
        horizontalListProducts[indexPath.item]
    }
    
    func numberOfRowsInSectionHorizontalListProducts() -> Int {
        horizontalListProducts.count
    }
    
    func numberOfRowsInSectionVerticalListProducts() -> Int {
        verticalListProducts.count
    }
    
    func goToProductDetail(at indexPath: IndexPath, section: Section) {
        switch section {
        case .horizontalListProducts:
            router?.navigate(.detail(presentation: horizontalListProducts[indexPath.item]))
        case .verticalListProducts:
            router?.navigate(.detail(presentation: verticalListProducts[indexPath.item]))
        }
    }
    
    func viewDidLoad() {
        view?.configureCollectionView()
        view?.configureNavigationBar()
        view?.configureSuperview()
        interactor?.fetchProducts()
    }
}

extension ProductListPresenter: ProductListInteractorOutputProtocol {
    func fetchVerticalListProductsOutputs(_ result: Result<[VListProductModel], any Error>) {
        switch result {
        case .success(let responseModel):
            makeVerticalListProductPresentation(with: responseModel)
            view?.reloadData()
        case .failure(let error):
            print("error")
        }
    }
    
    func fetchHorizontalListProductsOutputs(_ result: Result<[HListProductsModel], any Error>) {
        switch result {
        case .success(let responseModel):
            makeHorizontalListProductPresentation(with: responseModel)
            view?.reloadData()
        case .failure(let error):
            print("error")
        }
    }
}

extension ProductListPresenter {
    private func makeHorizontalListProductPresentation(with responseModel: [HListProductsModel]) {
        guard let products = responseModel.first?.products else { return }
        
        horizontalListProducts = products.map { product in
            return ProductPresentation(id: product.id,
                                       name: product.name,
                                       attribute: " ",
                                       price: product.priceText,
                                       imageURL: product.imageURL,
                                       currentAmount: "0")
        }
    }
    
    private func makeVerticalListProductPresentation(with responseModel: [VListProductModel]) {
        guard let products = responseModel.first?.products else { return }
        
        verticalListProducts = products.map { product in
            return ProductPresentation(id: product.id,
                                       name: product.name,
                                       attribute: product.attribute,
                                       price: product.priceText,
                                       imageURL: product.imageURL,
                                       currentAmount: "0")
        }
    }
}
