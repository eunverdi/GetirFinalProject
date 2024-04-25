//
//  MockProductDetailRouter.swift
//  GetirFinalProjectTests
//
//  Created by Ensar Batuhan Ünverdi on 25.04.2024.
//

import UIKit
@testable import GetirFinalProject

final class MockProductDetailRouter: ProductDetailRouterProtocol {
    
    var invokedNavigate = false
    var invokedNavigateCount = 0
    var invokedNavigateParameters: (route: GetirFinalProject.ProductDetailRoutes, Void)?

    func navigate(_ route: GetirFinalProject.ProductDetailRoutes) {
        invokedNavigate = true
        invokedNavigateCount += 1
        invokedNavigateParameters = (route, ())
    }
}
