//
//  ProductDetailInteractor.swift
//  GetirFinalProject
//
//  Created by Ensar Batuhan Ünverdi on 14.04.2024.
//

import Foundation

protocol ProductDetailInteractorOutputProtocol: AnyObject {
    func productCountOutput(productCount: String)
}

protocol ProductDetailInteractorProtocol {
    func checkIsAddedToCart(productID: String)
    func updateProductCount(product: ProductPresentation)
    func addProductToCart(productID: String)
    func deleteProductFromCart(productID: String)
}

final class ProductDetailInteractor {
    weak var output: ProductDetailInteractorOutputProtocol?
    
}


extension ProductDetailInteractor: ProductDetailInteractorProtocol {
    func updateProductCount(product: ProductPresentation) {
        ProductRepository.shared.updateProductAmount(with: product)
    }
    
    func addProductToCart(productID: String) {
        //
    }
    
    func deleteProductFromCart(productID: String) {
        //
    }
    
    func checkIsAddedToCart(productID: String) {
        ProductRepository.shared.checkIsAddedToCart(with: productID) { result in
            switch result {
            case .success(let isAdded):
                if isAdded {
                    ProductRepository.shared.getProductCount(with: productID) { result in
                        switch result {
                        case .success(let productCount):
                            self.output?.productCountOutput(productCount: productCount)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
