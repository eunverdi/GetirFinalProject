//
//  ProductListCellInteractor.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 16.04.2024.
//

import Foundation

protocol ProductListCellInteractorOutputProtocol: AnyObject {
    func checkIsAddedToCartOutput(isAdded: Bool)
    func deletedProductToCart()
    func addedProductToCart()
}

protocol ProductListCellInteractorProtocol: AnyObject {
    func checkIsAddedToCart(productID: String)
    func addProductToCart(product: ProductPresentation)
    func deleteProductToCart(product: ProductPresentation)
}

final class ProductListCellInteractor {
    weak var output: ProductListCellInteractorOutputProtocol?
}

extension ProductListCellInteractor: ProductListCellInteractorProtocol {
    func deleteProductToCart(product: ProductPresentation) {
        guard let productID = product.id else { return }
        ProductRepository.shared.deleteProduct(with: productID) { error in
            print("error while deleted products from cart \(error)")
        }
        output?.deletedProductToCart()
    }
    
    func addProductToCart(product: ProductPresentation) {
        guard let productID = product.id else { return }
        ProductRepository.shared.checkIsAddedToCart(with: productID) { [output] result in
            switch result {
            case .success(let isAdded):
                if !isAdded {
                    ProductRepository.shared.createProduct(with: product)
                    output?.addedProductToCart()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func checkIsAddedToCart(productID: String) {
        ProductRepository.shared.checkIsAddedToCart(with: productID) { result in
            switch result {
            case .success(let isAdded):
                self.output?.checkIsAddedToCartOutput(isAdded: isAdded)
            case .failure(let error):
                print(error)
            }
        }
    }
}
