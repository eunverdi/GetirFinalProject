//
//  CartListCellInteractor.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 21.04.2024.
//

import Foundation

protocol CartListCellInteractorOutputProtocol: AnyObject {
    func deletedProductToCart()
    func productCountFromCart(count: String)
}

protocol CartListCellInteractorProtocol: AnyObject {
    func checkProductCount(productID: String)
    func updateProductCount(product: ProductPresentation)
    func deleteProductToCart(product: ProductPresentation)
}

final class CartListCellInteractor {
    weak var output: CartListCellInteractorOutputProtocol?
}

extension CartListCellInteractor: CartListCellInteractorProtocol {
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
    
    func updateProductCount(product: ProductPresentation) {
        ProductRepository.shared.updateProductAmount(with: product)
        guard let productID = product.id else { return }
        checkProductCount(productID: productID)
    }
    
    func deleteProductToCart(product: ProductPresentation) {
        guard let productID = product.id else { return }
        ProductRepository.shared.deleteProduct(with: productID)
        output?.deletedProductToCart()
    }
}
