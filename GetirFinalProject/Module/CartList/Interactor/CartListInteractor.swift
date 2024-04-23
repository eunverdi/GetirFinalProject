//
//  CartListInteractor.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 21.04.2024.
//

import Foundation

protocol CartListInteractorOutputProtocol: AnyObject {
    func fetchProductsInCartOutput(_ products: [ProductInCart])
    func fetchRecommendedProductsOutputs(_ result: Result<[HListProductsModel], Error>)
    func deletedProductsInCartOutput()
}

protocol CartListInteractorProtocol {
    func fetchProductsInCart()
    func fetchRecommendedProducts()
    func deleteProducts(productsIDs: [String])
}

final class CartListInteractor {
    weak var output: CartListInteractorOutputProtocol?
    private let networkManager = NetworkManager()
}

extension CartListInteractor: CartListInteractorProtocol {
    func fetchRecommendedProducts() {
        networkManager.getHorizontalListProducts { [output] result in
            output?.fetchRecommendedProductsOutputs(result)
        }
    }
    
    func deleteProducts(productsIDs: [String]) {
        let _ = productsIDs.map { id in
            ProductRepository.shared.deleteProduct(with: id)
        }
        output?.deletedProductsInCartOutput()
    }
    
    func fetchProductsInCart() {
        ProductRepository.shared.getProductsFromPersistance { result in
            switch result {
            case .success(let products):
                self.output?.fetchProductsInCartOutput(products)
            case .failure(let error):
                print(error)
            }
        }
    }
}
