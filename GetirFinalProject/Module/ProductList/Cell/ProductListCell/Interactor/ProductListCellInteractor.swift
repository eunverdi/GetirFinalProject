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
    func productCountFromCart(count: String)
}

protocol ProductListCellInteractorProtocol: AnyObject {
    func checkIsAddedToCart(productID: String)
    func checkProductCount(productID: String)
    func updateProductCount(product: ProductPresentation)
    func addProductToCart(product: ProductPresentation)
    func deleteProductToCart(product: ProductPresentation)
}

final class ProductListCellInteractor {
    weak var output: ProductListCellInteractorOutputProtocol?
}

extension ProductListCellInteractor: ProductListCellInteractorProtocol {
    func updateProductCount(product: ProductPresentation) {
        ProductRepository.shared.updateProductAmount(with: product)
    }
    
    func checkProductCount(productID: String) {
        ProductRepository.shared.getProductCount(with: productID) { result in
            switch result {
            case .success(let count):
                self.output?.productCountFromCart(count: count)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deleteProductToCart(product: ProductPresentation) {
        guard let productID = product.id else { return }
        ProductRepository.shared.deleteProduct(with: productID)
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
