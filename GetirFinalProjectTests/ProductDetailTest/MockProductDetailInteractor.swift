//
//  MockProductDetailInteractor.swift
//  GetirFinalProjectTests
//
//  Created by Ensar Batuhan Ünverdi on 25.04.2024.
//

import Foundation
@testable import GetirFinalProject

final class MockProductDetailInteractor: ProductDetailInteractorProtocol {
    
    var invokedCheckIsAddedToCart = false
    var invokedCheckIsAddedToCartCount = 0
    var invokedCheckIsAddedToCartParameters: (productID: String, Void)?

    func checkIsAddedToCart(productID: String) {
        invokedCheckIsAddedToCart = true
        invokedCheckIsAddedToCartCount += 1
        invokedCheckIsAddedToCartParameters = (productID, ())
    }
    
    var invokedProductCount = false
    var invokedProductCountToCount = 0
    var invokedProductCountParameters: (product: GetirFinalProject.ProductPresentation, Void)?

    func updateProductCount(product: GetirFinalProject.ProductPresentation) {
        invokedProductCount = true
        invokedProductCountToCount += 1
        invokedProductCountParameters = (product, ())
    }
    
    var invokedAddToCart = false
    var invokedAddToCartCount = 0
    var invokedAddToCartParameters: (presentation: GetirFinalProject.ProductPresentation, Void)?

    func addProductToCart(presentation: GetirFinalProject.ProductPresentation) {
        invokedAddToCart = true
        invokedAddToCartCount += 1
        invokedAddToCartParameters = (presentation, ())
    }
    
    var invokedDeleteProductFromCart = false
    var invokedDeleteProductFromCartCount = 0
    var invokedDeleteProductFromCartParameters: (productID: String, Void)?
    
    func deleteProductFromCart(productID: String) {
        invokedDeleteProductFromCart = true
        invokedDeleteProductFromCartCount += 1
        invokedDeleteProductFromCartParameters = (productID, ())
    }
}
