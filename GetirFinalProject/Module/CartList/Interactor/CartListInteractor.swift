//
//  CartListInteractor.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 21.04.2024.
//

import Foundation

protocol CartListInteractorOutputProtocol: AnyObject {
    func fetchProductsInCartOutput(_ products: [ProductInCart])
    func deletedProductsInCartOutput()
}

protocol CartListInteractorProtocol {
    func fetchProducts()
    func deleteProducts(productsIDs: [String])
}

final class CartListInteractor {
    weak var output: CartListInteractorOutputProtocol?
}

extension CartListInteractor: CartListInteractorProtocol {
    func deleteProducts(productsIDs: [String]) {
        let _ = productsIDs.map { id in
            ProductRepository.shared.deleteProduct(with: id)
        }
        output?.deletedProductsInCartOutput()
    }
    
    func fetchProducts() {
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
