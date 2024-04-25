//
//  MockProductListInteractor.swift
//  GetirFinalProjectTests
//
//  Created by Ensar Batuhan Ünverdi on 25.04.2024.
//

import XCTest
@testable import GetirFinalProject

final class MockProductListInteractor: ProductListInteractorProtocol {
    var invokedFetchProducts = false
    var invokedFetchProductsCount = 0

    func fetchProducts() {
        invokedFetchProducts = true
        invokedFetchProductsCount += 1
    }
}
